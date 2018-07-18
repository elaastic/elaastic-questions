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

<div class="ui info message explanation">
    <g:set var="nbEvaluation" value="${theResponse.evaluationCount()}"/>

    <g:if test="${theResponse.meanGrade != null || theResponse.teacherExplanation}">
        <div class="ui top left attached teal label">

            <g:if test="${theResponse.meanGrade != null}">
                <g:formatNumber number="${theResponse.meanGrade}"
                                type="number"
                                maxFractionDigits="2"/>/5

                <span class="detail"
                      style="${theResponse.teacherExplanation ? 'margin-right: 1em;' : ''}">${nbEvaluation} ${nbEvaluation > 1 ? g.message(code: 'common.evaluations') : g.message(code: 'common.evaluation')}</span>
            </g:if>

            <g:if test="${theResponse.teacherExplanation}">
                <span style="color: gold"><i class="check icon"></i> <g:message code="player.sequence.teacherExplanation"/>
                </span>
            </g:if>

        </div>
    </g:if>


    <strong style="margin-top: 2rem !important; display: inline-block;">
        @${theResponse.learner.username}
    </strong>

    <br/>
    ${raw(theResponse.explanation)}

</div>