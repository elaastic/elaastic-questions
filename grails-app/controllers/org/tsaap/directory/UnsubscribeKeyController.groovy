package org.tsaap.directory

import grails.transaction.Transactional

@Transactional
class UnsubscribeKeyController {

    SettingsService settingsService

    def doUnsubscribeDaily() {
        def key = params.key
        def idUser = UnsubscribeKey.executeQuery("SELECT user from UnsubscribeKey where unsubscribe_key = :var", [var: key])

        settingsService.updateSettingsForUser(idUser[0], [dailyNotifications: false])

        render(view: '/directory/dailyNotifUnsubscribe')
    }

    def doUnsubscribeMention() {
        def key = params.key
        def idUser = UnsubscribeKey.executeQuery("SELECT user from UnsubscribeKey where unsubscribe_key = :var", [var: key])

        settingsService.updateSettingsForUser(idUser[0], [mentionNotifications: false])

        render(view: '/directory/mentionNotifUnsubscribe')
    }

}
