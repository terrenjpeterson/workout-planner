# Amazon Alexa - Workout Planner Skill

Custom Amazon Alexa Skill that provides the ability to build a workout plan to take to the gym.

**Table of Contents**
- [What template was used for this skill?](#alexa-template)
- [What exercises are supported?](#supported-exercises)
- [How does the user give permissions for the skill?](#alexa-permissions)
- [How do the API's work?](#alexa-apis)


## Alexa Template

I started this using the lists sample in the Alexa cookbook.
[Here](https://github.com/alexa/alexa-cookbook/tree/master/context/lists) is where the instructions are, including the source code for the lambda function.

## Supported Exercises

This supports a number of different exercises.

pushups, situps, twist abs, incline situp, dips
calf raise, leg extension, leg curl, barbell deadlift, barbell squat, dumbell hammer curl, preacher curl, cable pushdown, 
barbell pullover, lat pull down, seated row, shoulder press, barbell row, dumpbell press, bench press

## Alexa Permissions

When creating the skill, on the permissions tab, request both "Lists Read" and "Lists Write".

![](https://s3.amazonaws.com/workoutplannerskill/images/skill_permissions.png)

Then when a user enables the skill, they will also need to opt-in for the skill using the companion app to modify the settings.

![](https://s3.amazonaws.com/workoutplannerskill/images/permission_sliders.jpg)

## Alexa APIs

There is one main API that manages lists on Alexa, then different operations with it (GET, POST, DELETE) can then create new lists and add items to an existing one. Here is a code sample on how to create a new list. An object that gets passed in provides the name of the new list.  

https://api.alexa.com/v2/householdlists/

![](https://s3.amazonaws.com/workoutplannerskill/images/architecture.png)

```sh
    var path = "/v2/householdlists/";

    console.log("path:" + path);
	
    var postData = {
        "name": "Workout Tracker", //item value, with a string description up to 256 characters 
        "state": "active" // item status (Enum: "active" only)
    };        
    
    var consent_token = session.user.permissions.consentToken;

    var options = {
        host: api_url,
        port: api_port,
        path: path,
        method: 'POST',
        headers: {
            'Authorization': 'Bearer ' + consent_token,
            'Content-Type': 'application/json'
        }
    };

    var req = https.request(options, (res) => {
        console.log('statusCode:', res.statusCode);
        console.log('headers:', res.headers);
        var data = "";

        res.on('data', (d) => {
            console.log("data received:" + d);
            data += d;
        });
        res.on('error', (e) => {
            console.log("error received");
            console.error(e);
        });
        res.on('end', function() {
            console.log("ending post request");
            if (res.statusCode === 201) {
                var responseMsg = eval('(' + data + ')');
                console.log("new list id:" + responseMsg.listId);
                callback(res.statusCode, responseMsg.listId);
            } else {
                callback(res.statusCode, 0);
            }
        });
    });
    
    req.end(JSON.stringify(postData));
```
