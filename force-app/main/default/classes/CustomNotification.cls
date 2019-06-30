/**
 * Fun basic example of what an Apex Custom Notification API might look like! 
 *
    new CustomNotification()
        .type('BatchApexError')
        .title('Batch Error')
        .body('Some useful information')
        .sendToCurrentUser();
 */
public inherited sharing class CustomNotification {

    private String notificationTypeId;
    private String notificationTypeName;
    private String notificationBody;
    private String notificationTitle;
    private List<Id> recipientIds;
    private Id targetId;
    private Id senderId; 

    public CustomNotification() {
        this.targetId = UserInfo.getUserId();
    }    

    public CustomNotification type(String type) {
        this.notificationTypeName = type;
        return this;
    }

    public CustomNotification title(String title) {
        this.notificationTitle = title;
        return this;
    }

    public CustomNotification body(String body) {
        this.notificationBody = body;
        return this;
    }

    public CustomNotification sendToCurrentUser() {
        this.recipientIds = new List<ID> { UserInfo.getUserId() };
        return send();
    }

    // TODO: Add more methods to add multiple recipients for example
    // ...

    public CustomNotification send() {
        // Until there is an Apex API for Custom Notification 
        //   delegage to an Autolaunch Flow wrapper
        new FlowProcess()
            .named('SendCustomNotification')
            .with('CustomNotificationTypeName', this.notificationTypeName)
            .with('NotificationBody', this.notificationBody)
            .with('NotificationTitle', this.notificationTitle)
            .with('RecipientIds', this.recipientIds)
            .with('TargetId', this.targetId)
            .run(); 
        // TODO: Error handling
        // ...
        return this;       
    }
}
