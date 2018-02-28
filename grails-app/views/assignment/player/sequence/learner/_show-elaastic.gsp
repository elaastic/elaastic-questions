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

<g:set var="activeInteraction" value="${sequenceInstance.activeInteractionForLearner(user)}"/>
<g:render template="/assignment/player/sequence/learner/steps/steps-elaastic"
          model="[activeInteraction: activeInteraction]"/>


<g:render template="/assignment/player/statement/${userRole}/${sequenceInstance.state}-elaastic"
          model="[statementInstance: sequenceInstance.statement]"/>

<g:set var="currentInteraction" value="${activeInteraction}"/>
<g:render
        template="/assignment/player/${currentInteraction.interactionType}/${userRole}/${currentInteraction.stateForLearner(user)}-elaastic"
        model="[interactionInstance: currentInteraction, user: user, attempt: 1]"/>

