const AWS = require('aws-sdk');

AWS.config.update({
    accessKeyId: "AKIAIZKFNIVOTCL5CDKA",
    secretAccessKey: "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",
    "region": "us-east-1"
});
var cloudwatch = new AWS.CloudWatch();

exports.sendCloudWatchCount = (value) => {	
	var params = {
		MetricData: [{
			"MetricName": "Request",
			"Value": value,
			"Unit": "Count",
		}],
		Namespace: "CME"
	}
	cloudwatch.putMetricData(params, function(err, data) {
		if (err)
			console.log(err, err.stack);
		else
			console.log(data);
        });
};

exports.sendCloudWatchTime = (time) => {
    var params = {
		MetricData: [{
			"MetricName": "Uptime",
			"Value": time,
			"Unit": "Seconds",
		}],
		Namespace: "CME"
	}
    cloudwatch.putMetricData(params, function(err, data) {
		if (err)
			console.log(err, err.stack);
		else
			console.log(data);
        });
};

