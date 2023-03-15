@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
       HttpResponse res = new HttpResponse();
        
     if(req.getEndpoint().contains('/api/v1/me')){
        system.debug('=======req.getEndpoint()===='+req.getEndpoint());
        System.assertEquals('GET', req.getMethod()); 
        res.setHeader('Content-Type', 'application/json');
       // res.setBody('{"User": { "CreatedTimestamp": 1532676372,"EmailAddress": "varaprasad@dhruvsoft.com","GivenName": "Sugunakar","Id": "S-1-5-21-3780218636-2021254075-705714373-1603&d-926725079e","Locale": "es","ModifiedTimestamp": 1532679372,"OrganizationId": "d-926725079e","RecycleBinFolderId": "","RootFolderId": "","Status": "ACTIVE ","Surname": "Sugunakar","TimeZoneId": "S-1-5-21-3780218636-2021254075-705714373-1603&d-926725079e","Type": "ADMIN","Username": "varaprasad@dhruvsoft.com"}}');
         res.setBody('{"User":{"Id":"Sugunakar123","OrganizationId":"d-926725079e"}}');
         res.setStatusCode(200);
       }  
        
      // for getting root folder id  value  
        
     if(req.getEndpoint().contains('/api/v1/me/root')){
         system.debug('=======req.getEndpoint()===='+req.getEndpoint()); 
         System.assertEquals('GET', req.getMethod()); 
         res.setHeader('Content-Type', 'application/json');
        //res.setBody('{"Folders":[{"CreatedTimestamp":1532676372,"CreatorId": "S-1-5-21-3780218636-2021254075-705714373-1603&d-926725079e","Id": "90f0e11893d8e89eabc88a27154c26fb75d8e76211050f04cea0acc6e03f2972","Labels": [ "root1" ],"LatestVersionSize":100,"ModifiedTimestamp": number,"Name": "root","ParentFolderId": "S-1-5-21-3780218636-2021254075-705714373-1113%26d-926725079e","ResourceState": "ACTIVE ","Signature": "Sugunakar","Size": 22}]}');
         res.setBody('{"Folders":[{"Id": "90f0e11893d8e89eabc88a27154c26fb75d8e76211050f04cea0acc6e03f2972"}]}');
         res.setStatusCode(200);
       }
        
      // for folder creation We need to use POST
        
        if(req.getEndpoint().contains('/api/v1/folders') && (req.getMethod()=='POST')){
          system.debug('=======req.getEndpoint()===='+req.getEndpoint()); 
          System.assertEquals('POST', req.getMethod()); 
          res.setHeader('Content-Type', 'application/json');
          res.setBody('{"Metadata": { "CreatedTimestamp": 1532676372,"CreatorId": "S-1-5-21-3780218636-2021254075-705714373-1603&d-926725079e","Id": "3298ff11c2e0bf933b6987d113d0c70c43cf1ddc3033464579754f90a94ec7a0","Labels": [ "Sugunakar" ],"LatestVersionSize": 200,"ModifiedTimestamp": 1532678372,"Name": "Folder Name","ParentFolderId": "S-1-5-21-3780218636-2021254075-705714373-1113%26d-926725079e","ResourceState": "ACTIVE","Signature": "Sugunakar","Size": 200}}');
          res.setStatusCode(201);   
        }  
        
        // for deletring folder content
        if(req.getEndpoint().contains('/api/v1/folders') && (req.getMethod()=='DELETE')){
            //system.debug('=======req.getEndpoint()===='+req.getEndpoint());
            //System.assertEquals('DELETE', req.getMethod());
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(204);  
        }
        
        
       // for getting folder Contents  Document Name , Id  and Sub Folder id's 
       //  
        if(req.getEndpoint().contains('/api/v1/folders') && req.getEndpoint().contains('/contents')){ 
           system.debug('=======req.getEndpoint()===='+req.getEndpoint());
           System.assertEquals('GET', req.getMethod()); 
           res.setHeader('Content-Type', 'application/json');
           res.setBody('{"Documents": [{"Id":"1234567890","LatestVersionMetadata":{"id":"123456789011","Name":"Doucument Name"}}], "Folders": [{"Id":"90f0e11893d8e89eabc88a27154c26fb75d8e76211050f04cea0acc6e03f2972"}]}');   
           res.setStatusCode(200);
      }
    
        
        if(req.getEndpoint().contains('/api/v1/token')){
          system.debug('=======token req.getEndpoint()===='+req.getEndpoint());
           System.assertEquals('POST', req.getMethod()); 
           res.setHeader('Content-Type', 'application/json'); 
            res.setBody('{"AccessToken":"AccessToken123","RefreshToken":"RefreshToken123","User":{"Id":"S-1-5-21-3780218636-2021254075-705714373-1603&d-926725079e","OrganizationId":"d-926725079e"}}');    
            res.setStatusCode(201);
        }
         
        if(req.getEndpoint().contains('/api/v1/token/refresh')){
            res.setHeader('Content-Type', 'application/json'); 
            res.setBody('{"AccessToken":"AccessToken123","RefreshToken":"RefreshToken123","User":{"Id":"S-1-5-21-3780218636-2021254075-705714373-1603&d-926725079e","OrganizationId":"d-926725079e"}}');    
            res.setStatusCode(201);
        }  
            
        
        if(req.getEndpoint().contains('/api/v1/activities?resourceId=')){
          system.debug('=======req.getEndpoint()===='+req.getEndpoint());
          System.assertEquals('GET', req.getMethod()); 
          res.setHeader('Content-Type', 'application/json');
          res.setBody('{"UserActivities": [{"TimeStamp": 1532676372,"Initiator":{"Id": "S-1-5-21-3780218636-2021254075-705714373-1603&d-926725079e"}}]}');
          res.setStatusCode(200);
        }
        
       // for deleteing the Document
       
        if(req.getEndpoint().contains('/api/v1/documents/') && (req.getMethod()=='DELETE')){
          system.debug('=======req.getEndpoint()===='+req.getEndpoint());
          System.assertEquals('DELETE', req.getMethod());
          res.setHeader('Content-Type', 'application/json');
          res.setStatusCode(204);  
        }
        
        if(req.getEndpoint().contains('/api/v1/documents') && (req.getMethod()=='POST')){
          system.debug('=======req.getEndpoint()===='+req.getEndpoint());
          System.assertEquals('POST', req.getMethod());
          res.setHeader('Content-Type', 'application/json');
          res.setBody('{"Metadata": {"Id": "1234567890123456789","LatestVersionMetadata": {"Id": "912341234134123412341" ,"CreatorId": "S-1-5-21-3780218636-2021254075-705714373-1603&d-926725079e"}},"UploadMetadata": {"UploadUrl": "https://gb-us-west-2-prod-doc-source.s3.us-west-2.amazonaws.com"}}');
          res.setStatusCode(201);  
        }
     return res;
    }
}