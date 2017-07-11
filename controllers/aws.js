const AWS = require('aws-sdk');

AWS.config.update({
    accessKeyId: "AKIAJTS2E5MONLMBBRPA",
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
			"Value": value,
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

