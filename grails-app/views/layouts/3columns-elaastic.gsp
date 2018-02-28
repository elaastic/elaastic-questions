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
<%@ page import="org.tsaap.directory.RoleEnum" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible"/>
  <meta content="width=device-width, initial-scale=1, maximum-scale=2, user-scalable=no" name="viewport"/>
  <meta name="description"
        content="elaastic-questions">  %{-- TODO description --}%
  <meta name="author" content="Ticetime">
  <meta content="#ffffff" name="theme-color"/>
  <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}"
        type="image/x-icon">
  <title><g:layoutTitle default="elaastic-questions"/></title>
  <style type="text/css">[v-cloak] {
    display: none;
  }</style>
  <r:layoutResources/>

  %{-- TODO Find out how to load CK resources only when required... --}%
  <ckeditor:resources/>
</head>

<body class="elaastic three-columns">

<div class="ui left vertical inverted visible sidebar labeled icon menu"
     style="background-color: #4f7691; overflow: visible !important;">

  <g:link uri="/" class="header item" style="margin-top: 1em;">
    <img src="${resource(dir: 'images/elaastic/logos', file: 'Elaastic_pictoRVB.png')}" style="width: 48px"/>
  </g:link>

  <div class="ui divider"></div>

  <sec:ifAnyGranted
      roles="${RoleEnum.ADMIN_ROLE.label},${RoleEnum.TEACHER_ROLE.label}">
    <g:link controller="assignment"
            class="item"
            data-tooltip="${message(code: 'assignment.my.list.label')}"
            data-position="right center"
            data-inverted="">
      <i class="book icon"></i>
    </g:link>
  </sec:ifAnyGranted>

  <sec:ifAnyGranted
      roles="${RoleEnum.ADMIN_ROLE.label},${RoleEnum.STUDENT_ROLE.label}">
    <g:link controller="player"
            class="item"
            data-tooltip="${message(code: 'player.my.assignment.list.label')}"
            data-position="right center"
            data-inverted="">
      <i class="travel icon"></i>
    </g:link>
  </sec:ifAnyGranted>

  <sec:ifAnyGranted roles="${RoleEnum.ADMIN_ROLE.label}">
    <g:link controller="ltiConsumer"
            class="item"
            data-tooltip="${message(code: 'ltiConsumer.label', default: 'LtiConsumer')}"
            data-position="right center"
            data-inverted="">
      <i class="settings icon"></i>
    </g:link>
  </sec:ifAnyGranted>


  <div id="user-menu-dropdown"
       class="ui dropdown item"
       data-tooltip="${message(code: "layout.main.account")}"
       data-position="right center"
       data-inverted="">
    <i class="user icon"></i>

    <div class="ui vertical menu">
      <g:link controller="userAccount"
              action="doEdit"
              class="item"><i
          class="address card outline icon"></i> ${message(code: "layout.main.account")}</g:link>

      <tsaap:ifUserOwner>
        <div class="ui divider"></div>
        <g:link
            controller="userAccountBatchCreation" class="item">
          <i class="add user icon"></i> ${message(code: "layout.main.goUserAccountCreation")}
        </g:link>
        <div class="ui divider"></div>
      </tsaap:ifUserOwner>

      <g:link controller="logout" class="item"><i
          class="sign out icon"></i> ${message(code: "layout.main.disconnect")}</g:link>
    </div>
  </div>

  <div class="ui divider"></div>

  <div class="only mobile item"
       onclick="$('#layout-nav-modal').modal('show')"
       data-tooltip="${g.message(code: 'common.table-of-content')}"
       data-position="right center"
       data-inverted="">
    <i class="yellow browser icon"></i>
  </div>

  <g:pageProperty name="page.specificMenu"/>
</div>

<div class="wrap" style="margin-left: 90px;">
  <main>
    <aside id="layout-aside">
      <g:pageProperty name="page.aside"/>
    </aside>

    <article>
      <div class="ui container">
        <g:layoutBody/>
        <g:render template="/layouts/footer-elaastic"/>
      </div>
    </article>
  </main>

</div>

<div id="layout-nav-modal" class="ui modal">
  <div class="content">
    <g:pageProperty name="page.modal-aside"/>
  </div>
</div>

<r:script>
  $(document)
      .ready(function () {

    // Initialize dropdown
    $('#user-menu-dropdown').dropdown();
  });
</r:script>

<r:layoutResources/>
</body>
</html>