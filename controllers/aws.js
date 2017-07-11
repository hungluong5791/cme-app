const AWS = require('aws-sdk');

AWS.config.update({
    accessKeyId: "AKIAIZKFNIVOTCL5CDKA",
    secretAccessKey: "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",
    region: "us-east-1"
});
var cloudwatch = new AWS.CloudWatch();

exports.sendCloudWatchCount = (name, value) => {
    var params = {
        MetricData: [
            {
                MetricName: name,
                Dimensions: [
                    {
                        Name: 'Application',
                        Value: 'cme-app'
                    },
                ],
                Value: value,
                Unit: "Count",

            }
        ],

        Namespace: "CME"
    }
    cloudwatch.putMetricData(params, function (err, data) {
        if (err)
            console.log(err, err.stack);
        else
            console.log(data);
    });
};

exports.sendCloudWatchTime = (name, time) => {
    var params = {
        MetricData: [{
            MetricName: name,
            Dimensions: [
                {
                    Name: 'Application',
                    Value: 'cme-app'
                },
            ],
            Value: time,
            Unit: "Seconds",
        }],
        Namespace: "CME"
    }
    cloudwatch.putMetricData(params, function (err, data) {
        if (err)
            console.log(err, err.stack);
        else
            console.log(data);
    });
};

exports.sendCloudWatchTimeMilis = (name, time) => {
    var params = {
        MetricData: [{
            MetricName: name,
            Dimensions: [
                {
                    Name: 'Application',
                    Value: 'cme-app'
                },
            ],
            Value: time,
            Unit: "Milliseconds",
        }],
        Namespace: "CME"
    }
    cloudwatch.putMetricData(params, function (err, data) {
        if (err)
            console.log(err, err.stack);
        else
            console.log(data);
    });
};

