%{--
  - Copyright 2015 Tsaap Development Group
  -
  - Licensed under the Apache License, Version 2.0 (the "License");
  - you may not use this file except in compliance with the License.
  - You may obtain a copy of the License at
  -
  -    http://www.apache.org/licenses/LICENSE-2.0
  -
  - Unless required by applicable law or agreed to in writing, software
  - distributed under the License is distributed on an "AS IS" BASIS,
  - WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  - See the License for the specific language governing permissions and
  - limitations under the License.
  --}%




<%@ page import="org.tsaap.questions.TextBlock" %>
<g:set var="question" value="${note.question}"/>
<g:set var="resultMatrix" value="${sessionPhase.resultMatrix}"/>
<g:set var="indexAnsBlock" value="${0}"/>
<div class="question" id="question_${note.id}">
    <p>Results <strong>${question.title}</strong> - (response count : ${sessionPhase.responseCount()})</p>
    <g:each var="block" in="${question.blockList}">
        <g:if test="${block instanceof TextBlock}">
            <p>${block.text}</p>
        </g:if>
        <g:else>
            <g:render template="/questions/${question.questionType.name()}AnswerBlockResult" model="[block: block,resultMap:resultMatrix[indexAnsBlock++]]"/>
        </g:else>
    </g:each>
    Click to see details
</div>