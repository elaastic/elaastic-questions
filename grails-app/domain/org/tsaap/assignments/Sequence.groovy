package org.tsaap.assignments

import org.hibernate.FetchMode
import org.tsaap.assignments.interactions.EvaluationSpecification
import org.tsaap.assignments.interactions.ResponseSubmissionSpecification
import org.tsaap.directory.User

class Sequence {

    Integer rank

    Date dateCreated
    Date lastUpdated

    User owner
    Assignment assignment
    Statement statement
    String executionContext = ExecutionContextType.FaceToFace.name()

    Interaction activeInteraction
    String state = StateType.beforeStart.name()

    static constraints = {
        activeInteraction nullable: true
        state inList: StateType.values()*.name()
        executionContext inList: ExecutionContextType.values()*.name()
    }

    static transients = ['interactions', 'content', 'title',
                         'responseSubmissionSpecification', 'evaluationSpecification', 'responseSubmissionInteraction',
                         'evaluationInteraction', 'readInteraction']

    /**
     * Find all interactions
     * @return the interactions
     */
    List<Interaction> getInteractions() {
        if (id == null) {
            return null
        }
        Interaction.findAllBySequence(this, [sort: 'rank', order: 'asc'])
    }

    /**
     * Get the response submission interaction
     * @return the response submission interaction
     */
    Interaction getResponseSubmissionInteraction() {
        def result = null
        if (interactions?.size() > 0) {
            for (int i = 0; i < interactions.size(); i++) {
                if (interactions[i].isResponseSubmission()) {
                    result = interactions[i]
                    break
                }
            }
        }
        result
    }

    /**
     * Get the evaluation interaction
     * @return the evaluation interaction
     */
    Interaction getEvaluationInteraction() {
        def result = null
        if (interactions?.size() > 0) {
            for (int i = 0; i < interactions.size(); i++) {
                if (interactions[i].isEvaluation()) {
                    result = interactions[i]
                    break
                }
            }
        }
        result
    }

    /**
     * Get the read interaction
     * @return the read interaction
     */
    Interaction getReadInteraction() {
        def result = null
        if (interactions?.size() > 0) {
            for (int i = 0; i < interactions.size(); i++) {
                if (interactions[i].isRead()) {
                    result = interactions[i]
                    break
                }
            }
        }
        result
    }

    /**
     * Get the response submission specification
     * @return the response submission specification
     */
    ResponseSubmissionSpecification getResponseSubmissionSpecification() {
        def result = null
        if (interactions?.size() > 0) {
            for (int i = 0; i < interactions.size(); i++) {
                if (interactions[i].isResponseSubmission()) {
                    result = interactions[i].interactionSpecification
                    break
                }
            }
        }
        result
    }

    /**
     * Find the active interaction for learner
     * @param learner the learner
     * @return the active interaction
     */
    Interaction activeInteractionForLearner(User learner) {
        def interaction
        if (executionIsFaceToFace()) {
            interaction = this.activeInteraction
        } else {
            LearnerSequence learnerSequence = findOrCreateLearnerSequence(learner)
            interaction = learnerSequence.activeInteraction
        }
        interaction
    }

    /**
     * Update the active interaction for a given learner
     * @param learner the learner
     * @param phaseRank the current phase rank
     * @return
     */
    LearnerSequence updateActiveInteractionForLearner(User learner, int phaseRank) {
        LearnerSequence learnerSequence = findOrCreateLearnerSequence(learner)
        if (phaseRank == 1) {
            learnerSequence.activeInteraction = this.evaluationInteraction
        } else {
            learnerSequence.activeInteraction = this.readInteraction
        }
        learnerSequence.save()
        learnerSequence
    }

    /**
     * Get the evaluation specification
     * @return the evaluation specification
     */
    EvaluationSpecification getEvaluationSpecification() {
        def result = null
        if (interactions?.size() > 0) {
            for (int i = 0; i < interactions.size(); i++) {
                if (interactions[i].isEvaluation()) {
                    result = interactions[i].interactionSpecification
                    break
                }
            }
        }
        result
    }

    /**
     * Get the title of the statement
     * @return the title
     */
    String getTitle() {
        statement?.title
    }

    /**
     * Get the content of the statement
     * @return the content
     */
    String getContent() {
        statement?.content
    }

    /**
     * Indicate if sequence execution is blended or distance
     * @return true if sequence execution is blended or distance
     */
    boolean executionIsBlendedOrDistance() {
        executionIsBlended() || executionIsDistance()
    }

    /**
     * Indicate if sequence execution is distance
     * @return true if sequence execution is distance
     */
    boolean executionIsDistance() {
        executionContext == ExecutionContextType.Distance.name()
    }

    /**
     * Indicate if sequence execution is blended
     * @return true if sequence execution is blended
     */
    boolean executionIsBlended() {
        executionContext == ExecutionContextType.Blended.name()
    }

    boolean executionIsFaceToFace() {
        executionContext == ExecutionContextType.FaceToFace.name()
    }

    /**
     * Find all recommended responses for user
     * @param user the user
     * @return the response list
     */
    List<InteractionResponse> findRecommendedResponsesForUser(User user) {
        def responseInteraction = responseSubmissionInteraction
        InteractionResponse userResponse = InteractionResponse.findByInteractionAndLearnerAndAttempt(responseInteraction, user, 1)
        def res
        if (userResponse) {
            res = responseInteraction.explanationRecommendationMap()[userResponse.id as String].collect {
                InteractionResponse.get(it)
            }
        } else {
            res = []
        }
        res
    }

    /**
     * Find all good responses with explanations
     * @return the good responses
     */
    List<InteractionResponse> findAllGoodResponses() {
        Interaction interaction = responseSubmissionInteraction
        InteractionResponse.findAllByInteractionAndAttemptAndScore(interaction, 1, 100f,
                [sort: "meanGrade", order: "desc"])
    }

    /**
     * Find all open responses with explanations
     * @return the open responses
     */
    List<InteractionResponse> findAllOpenResponses() {
        Interaction interaction = responseSubmissionInteraction
        def res = InteractionResponse.findAllByInteraction(interaction,
                [sort: "meanGrade", order: "desc"])
        res
    }

    /**
     * Return all bad responses with explanations for the sequence
     * Responses in returned structure can be accessed this way:
     * map[score][answerGroup][index] where
     * score is a Float eg: 100.0, 0.0, -50.0
     * answerGroup is a String eg: "1", "1,3", ""
     * index is an index on the response list for answerGroup eg: 0, 4
     * @param sessionPhase
     * @return
     */
    Map<Float, Map<String, List<InteractionResponse>>> findAllBadResponses() {
        def list
        Map map = [:]
        Interaction interaction = responseSubmissionInteraction
        list = InteractionResponse.withCriteria {
            eq('interaction', interaction)
            eq('attempt', 1)
            lt('score', 100.0f)
            order('score', 'desc')
            'learner' {
                order('normalizedUsername', 'asc')
            }
            fetchMode('user', FetchMode.JOIN)
        }
        list.each {
            def answers = it.choiceListSpecification
            if (!map[it.score]) {
                def answerMap = [:]
                answerMap.put(answers, [it])
                map[it.score] = answerMap
            } else {
                if (!map[it.score][answers]) {
                    map[it.score][answers] = [it]
                } else {
                    map[it.score][answers].push(it)
                }
            }
        }
        map
    }

    /**
     *
     * @return true if the sequence has explanations
     */
    boolean hasExplanations() {
        responseSubmissionSpecification?.studentsProvideExplanation
    }

    /**
     *
     * @return true if the sequence is played with default 3 phases process
     */
    boolean isDefaultProcess() {
        responseSubmissionSpecification?.studentsProvideExplanation
    }

    /**
     *
     * @return true if the sequence is played with short 2 phases process
     */
    boolean isShortProcess() {
        !isDefaultProcess()
    }


    boolean isStopped() {
        state == StateType.afterStop.name()
    }

    /**
     * Find or create learner sequence
     * @param learner the learner
     */
    private LearnerSequence findOrCreateLearnerSequence(User learner) {
        LearnerSequence ls = LearnerSequence.findByLearnerAndSequence(learner,this)
        if (!ls) {
            ls = new LearnerSequence(learner: learner, sequence: this)
            if (activeInteraction) {
                ls.activeInteraction = responseSubmissionInteraction
            }
            ls.save()
        }
        if (!ls.activeInteraction && activeInteraction) {
            ls.activeInteraction = responseSubmissionInteraction
            ls.save()
        }
        ls
    }


}

enum StateType {
    beforeStart,
    show,
    afterStop
}

enum ExecutionContextType {
    FaceToFace,
    Distance,
    Blended
}