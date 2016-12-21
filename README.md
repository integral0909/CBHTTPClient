# CBHTTPClient
## Simple implementation of a class CBHTTPClient that satisfies these requirements:
1. It can be initialized with an HTTP REST API URL
2. It can have a delegate
3. It has one method: -(void)sendRequest:(NSDictionary *)params. When the method is called, it 
    sends a HTTP GET request to the API then:
1. If the API returns http 200: call -requestOK: on its delegate object
2. If the API returns http 500: call -requestTryAgain: on its delegate object
3. If it encounters an http timeout error: call -requestTimeout: on its delegate object
4. Unit test for -sendRequest: method.
