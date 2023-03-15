public with sharing class DocdownloadExt {

public String documentname{ get; set; }
public String docid{ get; set; }
public string getdocId()
{
return docid;
}
public void documentId()
{
documentname=System.currentPageReference().getParameters().get('documentname');
List<Document> lstDocument = [Select Id,Name from Document where Name =:documentname limit 1];
string strOrgId = UserInfo.getOrganizationId();
docid=lstDocument[0].Id;
System.debug('docid:'+docid);

}


}