%{--
  -
  -  Copyright (C) 2017 Ticetime
  -
  -      This program is free software: you can redistribute it and/or modify
  -      it under the terms of the GNU Affero General Public License as published by
  -      the Free Software Foundation, either version 3 of the License, or
  -      (at your option) any later version.
  -
  -      This program is distributed in the hope that it will be useful,
  -      but WITHOUT ANY WARRANTY; without even the implied warranty of
  -      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  -      GNU Affero General Public License for more details.
  -
  -      You should have received a copy of the GNU Affero General Public License
  -      along with this program.  If not, see <http://www.gnu.org/licenses/>.
  -
  --}%

<%@ page import="org.tsaap.assignments.InteractionType" %>
<%@ page import="org.tsaap.assignments.StateType" %>

<g:set var="questionType" value="${sequenceInstance.statement.questionType.name()}"/>

<g:render template="/assignment/player/sequence/steps/steps-elaastic"
          model="[sequence              : sequenceInstance,
                  stateByInteractionType: [
                      (InteractionType.ResponseSubmission): StateType.beforeStart.name(),
                      (InteractionType.Evaluation)        : StateType.beforeStart.name(),
                      (InteractionType.Read)              : StateType.beforeStart.name(),
                  ]]"/>

<div class="ui attached stackable icon menu">
  <a class="item" style="width: 100%; text-align: center; display: block; outline: none;"
     href="#"
     onclick="$('#interactionSpec_${sequenceInstance.id}').modal('show');">
    <i class="green play icon"></i>
    &nbsp; ${message(code: "player.sequence.start")}
  </a>
</div>

<div class="ui bottom attached warning message">
  ${message(code: "player.sequence.beforeStart.message")}
</div>

<g:render template="/assignment/player/statement/show-elaastic"
          model="[statementInstance: sequenceInstance.statement, hideStatement: false]"/>


<div class="ui small modal" id="interactionSpec_${sequenceInstance.id}">

  <div class="header" style="border-bottom: 1px solid rgba(14, 110, 184, .15);">
    <g:message code="sequence.interaction.configure.title"/>
  </div>

  <div class="content">
    <g:form class="ui form"       
            name="interactionSpec_${sequenceInstance.id}_form"
            controller="player"
            action="initializeInteractionsAndStartFirst">
      <input type="hidden" name="id" value="${sequenceInstance.id}">

      <div class="inline fields">
        <label><g:message code="sequence.interaction.executionContext"/> :</label>

        <div class="field">
          <div class="ui radio checkbox">
            <input type="radio" name="executionContext" id="executionContext_${sequenceInstance.id}_${questionType}"
                   value="FaceToFace" checked="checked"/>
            <label for="executionContext_${sequenceInstance.id}_${questionType}">
              <g:message code="sequence.interaction.executionContext.faceToFace"
                         for="executionContext_${sequenceInstance.id}_${questionType}"/>
            </label>
          </div>
        </div>

        <div class="field">
          <div class="ui radio checkbox fieldExecutionContext">
            <input type="radio" name="executionContext" id="executionContext_${sequenceInstance.id}_${questionType}"
                   value="Distance"/>
            <label for="executionContext_${sequenceInstance.id}_${questionType}">
              <g:message code="sequence.interaction.executionContext.distance"/>
            </label>
          </div>
        </div>

        <div class="field">
          <div class="ui radio checkbox">
            <input type="radio" name="executionContext" id="executionContext_${sequenceInstance.id}_${questionType}"
                   value="Blended">
            <label for="executionContext_${sequenceInstance.id}_${questionType}">
              <g:message code="sequence.interaction.executionContext.blended"/>
            </label>
          </div>
        </div>
      </div>

      <div class="ui info message" id="context-faceToFace-notice">
        <g:message code="sequence.interaction.executionContext.faceToFace.notice" />
      </div>

      <div class="ui info message" id="context-distance-notice" style="display: none">
        <g:message code="sequence.interaction.executionContext.distance.notice" />
      </div>

      <div class="ui info message" id="context-blended-notice" style="display: none">
        <g:message code="sequence.interaction.executionContext.blended.notice" />
      </div>

      <div class="ui  divider"></div>

      <div id="configuration_${sequenceInstance.id}">
        <g:render template="/assignment/player/sequence/teacher/interactions_configuration-elaastic"
                  model="[sequenceId: sequenceInstance.id, questionType: questionType]"/>
      </div>

      <div class="ui hidden divider"></div>

      <div>
        <g:hiddenField name="reloadPage" value="${true}"/>
      </div>
    </g:form>
  </div>

  <div class="actions">
    <div class="ui approve primary button">${message(code: "player.sequence.start")}</div>

    <div class="ui cancel button">${message(code: "common.cancel")}</div>
  </div>
</div>

<r:script>
  $(document).ready(function() {
    $('#interactionSpec_${sequenceInstance.id}').modal({
      onApprove: function() {
        $('#interactionSpec_${sequenceInstance.id}_form').submit();
      }
    });
  });
</r:script>
