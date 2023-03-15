public class outlookmail {
   /* public String sendTo { get; set; }
    public outlookmail() {} 
    public void sendInvite() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'harinath.414@outlook.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Meeting Invitation');
        mail.setPlainTextBody('You are invited to this class meeting');
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.filename = 'meeting.ics';
        attach.ContentType = 'text/calendar; charset=utf-8; method=REQUEST';
        attach.inline = true;
        attach.body = invite();
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
        Messaging.SendEmailResult[] er = Messaging.sendEmail(new Messaging.Email[] {mail});
       
    }
    private Blob invite() {
        String txtInvite = ''; 
        txtInvite += 'BEGIN:VCALENDAR\n';
        txtInvite += 'PRODID:-//Microsoft Corporation//Outlook 16.0 MIMEDIR//EN\n';
        txtInvite += 'VERSION:2.0\n';
        txtInvite += 'METHOD:REQUEST\n';
        txtInvite += 'REPLAY:ACCEPTED\n';	
        txtInvite += 'X-MS-OLK-FORCEINSPECTOROPEN:TRUE\n';
        txtInvite += 'BEGIN:VEVENT\n';
        txtInvite += 'CLASS:PUBLIC\n';
        txtInvite += 'CREATED:20200509T203709Z\n';
        txtInvite += 'DTEND:20200509T010000Z\n';
        txtInvite += 'DTSTAMP:20200509T203709Z\n';
        txtInvite += 'DTSTART:20200509T000000Z\n';
        txtInvite += 'LAST-MODIFIED:20200509T203709Z\n';
        txtInvite += 'LOCATION:Online\n';
        txtInvite += 'PRIORITY:5\n';
        txtInvite += 'SEQUENCE:0\n';
        txtInvite += 'SUMMARY;';
        txtInvite += 'LANGUAGE=en-us:Meeting\n';
        txtInvite += 'TRANSP:OPAQUE\n';
        txtInvite += 'UID:4036587160834EA4AE7848CBD028D1D200000000000000000000000000000000\n';
        txtInvite += 'X-ALT-DESC;FMTTYPE=text/html:<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN"><HTML><HEAD><META NAME="Generator" CONTENT="MS Exchange Server version 08.00.0681.000"><TITLE></TITLE></HEAD><BODY><!-- Converted from text/plain format --></BODY></HTML>\n';
        txtInvite += 'X-MICROSOFT-CDO-BUSYSTATUS:BUSY\n';
        txtInvite += 'X-MICROSOFT-CDO-IMPORTANCE:1\n';
        txtInvite += 'END:VEVENT\n';
        txtInvite += 'END:VCALENDAR';
 
        return Blob.valueOf(txtInvite);
    }*/
}