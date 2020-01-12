# Custom Notification Demos

Sample Process Builder, Flow and Apex code illustrating how to utilizae Custom Notifications in Lightning Experience and Salesforce Mobile. See [blog for more details](https://andyinthecloud.com/2019/06/30/getting-your-users-attention-with-custom-notifications/).

Setup Instructions
------------------

- Deploy to DX scratch org via ```sfdx force:source:push```
- Run ```sfdx force:source:push``` again

Demo Instructions
-----------------

- Open the scratch org with ```sfdx force:org:open```
- Run ```sfdx force:apex:execute``` (without parameters)
- Paste the following sample code in and press the indicated keyboard shortcut to run the code.

```
new CustomNotification()
    .type('BatchApexError')
    .title('Batch Error')
    .body('Some useful information')
    .sendToCurrentUser();
```

Or to test the Batch Apex Error Event handler....

```
Database.executeBatch(new MyBadJob());
```

Finally if you want to see notifications on your mobile, you will need to generate a user password via ```sfdx force:user:password:generate``` to login to the scratch org (be sure to select sandbox login from the mobile).
