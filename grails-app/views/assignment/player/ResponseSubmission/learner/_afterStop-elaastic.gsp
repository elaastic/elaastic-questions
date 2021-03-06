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

<div class="ui segment">
  <div class="ui dividing header">
    <g:message code="common.answer"/>
  </div>

  <g:if test="${interactionInstance.hasResponseForUser(user, attempt)}">
    <div class="ui blue bottom attached message">
      <g:message code="player.sequence.interaction.responseSubmission.hasBeenRecorded"/>
    </div>
  </g:if>
  <g:else>
    <div class="ui blue bottom attached message">
      <g:message code="player.sequence.interaction.responseSubmission.tooLate"/>
    </div>
  </g:else>

</div>
