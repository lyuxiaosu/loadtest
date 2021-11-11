const loadtest = require("../lib/loadtest");
const configuration = require('../sample/sledge_w2_65.json');
const execSync = require('child_process').execSync;

function statusCallback(error, result, latency) {
    console.log('----');
    console.log('Current latency %j, result %j, error %j', latency);
    console.log('Request elapsed milliseconds: ', result.requestElapsed);
    console.log('Request index: ', result.requestIndex);
    console.log('Request loadtest() instance index: ', result.instanceIndex);
}

rps = configuration.rps;
rpsInterval = configuration.interval;

index = 0;

const fs = require('fs');
const path = require('path');
function readBody(filename, option) {
        if (typeof filename !== 'string') {
                console.error('Invalid file to open with %s: %s', option, filename);
                help();
        }

        if (path.extname(filename) === '.js') {
                return require(path.resolve(filename));
        }

	const ret = fs.readFileSync(filename);
        return ret;
}

const IH = '10.10.1.1';
const IP = '10003';
console.log(IH+':'+ IP);

const options = {
    url: 'http://' + IH + ':' + IP,
    maxRequests: rps.reduce((a, b) => a + b, 0)*rpsInterval,
    // maxRequests: 10000,
    //headers: { 'Host': 'autoscale-go-1.default.example.com' },
    //method: 'POST',
    body: readBody("/users/xiaosuGW/sledge-serverless-framework/runtime/tests/305k.jpg",'-p'),
    contentType: 'image/jpg',
    // starting rps can be an array or a single value
    requestsPerSecond: rps, //[20, 20, 20, 20],
    concurrency: 1,
    debug:true,
    /**
     * GWU:Custom parameters
     */
    rpsInterval,
    agentKeepAlive: false,
};

loadtest.loadTest(options, function (error, result) {
    if (error) {
        return console.error('Got an error: %s', error);
    }
    console.log(result);
    console.log('Tests run successfully');
});
