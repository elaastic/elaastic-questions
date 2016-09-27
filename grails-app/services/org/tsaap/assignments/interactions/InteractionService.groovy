package org.tsaap.assignments.interactions

import grails.transaction.Transactional
import org.tsaap.assignments.Interaction
import org.tsaap.assignments.Sequence
import org.tsaap.assignments.StateType
import org.tsaap.contracts.Contract
import org.tsaap.directory.User

@Transactional
class InteractionService {

    /**
     * Start an interaction
     * @param interaction the interaction to start
     * @return the started interaction
     */
    Interaction startInteraction(Interaction interaction, User user) {
        Contract.requires(interaction.owner == user, ONLY_OWNER_CAN_START_INTERACTION)
        Sequence sequence = interaction.sequence
        interaction.state = StateType.show.name()
        sequence.state = StateType.show.name()
        interaction.save()
        sequence.save()
        interaction
    }

    /**
     * Stop an interaction
     * @param interaction the interaction to stop
     * @return the stopped interaction
     */
    Interaction stopInteraction(Interaction interaction, User user) {
        Contract.requires(interaction.owner == user,ONLY_OWNER_CAN_STOP_INTERACTION)
        Contract.requires(interaction.state == StateType.show.name(),INTERACTION_IS_NOT_STARTED)
        interaction.state = StateType.afterStop.name()
        interaction.save()
        updateActiveInteractionInSequence(interaction)
        interaction
    }


    private void updateActiveInteractionInSequence(Interaction interaction) {
        Sequence sequence = interaction.sequence
        def rank = interaction.rank + 1
        Interaction newActInter = Interaction.findBySequenceAndRank(sequence, rank)
        sequence.activeInteraction = newActInter
        sequence.save()
    }

    private static final String ONLY_OWNER_CAN_START_INTERACTION = 'Only owner can start an interaction'
    private static final String ONLY_OWNER_CAN_STOP_INTERACTION = 'Only owner can stop an interaction'
    private static final String INTERACTION_IS_NOT_STARTED = 'The interaction is not started'
}
