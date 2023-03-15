public with sharing class JobFilesListExtension 
{

    public JobFilesListExtension() 
    {
        jobfeedlist = new list<Job__Feed>();
        fwlist = new list<FeedWrapper>();
        
        for(job__feed jfeed : [SELECT Id, ParentId, Title, Body, ContentData, RelatedRecordId, ContentFileName, ContentDescription, ContentType, ContentSize, InsertedById FROM Job__Feed])
        {
            if(jfeed.ContentData != NULL)
            {
            jobfeedlist.add(jfeed);
            FeedWrapper fw = new FeedWrapper(jfeed,jfeed.ContentData);
            fwlist.add(fw);
            }
        }
    }


    transient Public list<Job__Feed> jobfeedlist{get;set;}
    public String dis{get;set;}
    transient public list<FeedWrapper> fwlist{get;set;}
    public JobFilesListExtension(ApexPages.StandardController controller) 
    {
        jobfeedlist = new list<Job__Feed>();
        fwlist = new list<FeedWrapper>();
        
        for(job__feed jfeed : [SELECT Id, ParentId, Title, Body, ContentData, RelatedRecordId, ContentFileName, ContentDescription, ContentType, ContentSize, InsertedById FROM Job__Feed])
        {
            if(jfeed.ContentData != NULL)
            {
            jobfeedlist.add(jfeed);
            FeedWrapper fw = new FeedWrapper(jfeed,jfeed.ContentData);
            fwlist.add(fw);
            }
        }
    }
    
    public void send()
    {
                            String ePoint = 'https://api.cloudconvert.com/convert';
                            blob b=blob.valueOf('Blob[586379]');
                            String A = EncodingUtil.Base64Encode(b);
                            HttpRequest req=new HttpRequest();
                            req.setEndPoint(ePoint);
                            req.setMethod('POST');
                            
                            req.setHeader('apikey', '-4AEKV0JCwuR3bM9vkN6xJYmk-vio_XO9qZcwXEAj_HDjR8PKEj2ZdCm4YnWVKgtPa1WPOJwUu9QYY--XlFWIg');
                            req.setHeader('inputformat','pdf');
                            req.setHeader('outputformat','html');
                            req.setHeader('input','base64');
                            req.setHeader('filename','1.pdf');
                            req.setHeader('wait','true');
                            req.setHeader('download','inline');
                            req.setHeader('file', A);
                            Http p=new Http();
                            HttpResponse res = p.send(req);
                            String SaasuResponse = res.getBody();
                            System.debug('hieeeeee'+saasuresponse);
                            dis = saasuresponse;
    }
    
    //EncodingUtil.Base64Encode(att.body);
  /*  public String pdf(Blob body) 
    {
        
            return EncodingUtil.Base64Encode(body);
       
    } */
    
    public class FeedWrapper
    {
        public Job__Feed jfd{get;set;}
        public String cd{get;set;}
        public blob dc{get;set;}
        FeedWrapper(Job__Feed jfa, Blob bd)
        {
             this.jfd = jfa;
            //this.cd = EncodingUtil.Base64Encode(bd);
            this.cd = String.valueof(bd);
            this.dc = bd;
        }
        
    } 
    

}