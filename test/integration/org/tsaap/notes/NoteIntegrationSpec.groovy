/*
 * Copyright 2013 Tsaap Development Group
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.tsaap.notes

import org.tsaap.BootstrapTestService
import org.tsaap.questions.LiveSession
import org.tsaap.questions.LiveSessionResponse
import org.tsaap.questions.LiveSessionService
import org.tsaap.questions.Question
import org.tsaap.questions.UserResponse
import spock.lang.Specification

class NoteIntegrationSpec extends Specification {
    BootstrapTestService bootstrapTestService
    NoteService noteService
    LiveSessionService liveSessionService

    def setup() {
        bootstrapTestService.initializeTests()
    }


    void "test the finding of the last live session for a note"() {
        when: "a note is not a question"
        Note note = noteService.addNote(bootstrapTestService.learnerMary,"not a question")

        then: "no live session found"
        !note.findLiveSession()

        when:"a note is a question but that has no live session"
        note = noteService.addNote(bootstrapTestService.learnerMary,"::a question:: what ? {=this ~that}")

        then:"no live session found"
        !note.findLiveSession()

        and:"the note has one live session"
        LiveSession liveSession = liveSessionService.createLiveSessionForNote(bootstrapTestService.learnerMary,note)

        then:"a live session is found"
        note.findLiveSession() == liveSession

        when:"the note is a question and has more than one live session"
        LiveSession lastLiveSession = liveSessionService.createLiveSessionForNote(bootstrapTestService.learnerMary, note)

        then:"the last live session is returned"
        note.findLiveSession() == lastLiveSession

    }


}
