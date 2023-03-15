import { LightningElement, wire, track, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { loadScript } from 'lightning/platformResourceLoader';
import libUrl from '@salesforce/resourceUrl/lib';
import myfilesUrl from '@salesforce/resourceUrl/myfiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import mimeTypes from './mimeTypes'
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import saveDocument from '@salesforce/apex/PDFTron_Task_Creator.saveDocument';

import getRelatedDocuments from '@salesforce/apex/PDFTron_Task_Creator.getRelatedDocuments';
//import fetchJSMetadata from '@salesforce/apex/PDFTron_ContentVersionController.fetchJSMetadata';


import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id'; //this is how you will retreive the USER ID of current in user.
import NAME_FIELD from '@salesforce/schema/User.Name';

import { refreshApex } from '@salesforce/apex';


function _base64ToArrayBuffer(base64) { 
  var binary_string =  window.atob(base64);
  var len = binary_string.length;
  var bytes = new Uint8Array( len );
  for (var i = 0; i < len; i++)        {
      bytes[i] = binary_string.charCodeAt(i);
  }
  return bytes.buffer;
}

var myVar;
function mouseOutSetTimeFunction() {
  myVar = setTimeout(function(){ 
    //alert("Hello");
    const evte = new ShowToastEvent({
      title: 'Warning',
      message: 'Your changes have not been saved. Please click the save button.',
      variant: 'Warning',
      mode: 'dismissable'
    });
    this.dispatchEvent(evte);
  }, 0.02 * 60 * 1000);
}

function mouseinClearSetTimeFunction() {
  clearTimeout(myVar);
}

export default class PdftronWvInstanceTask extends LightningElement {

  @track FileLoading = true;
  @track isSaved = false;
  @track error ;
  @track userName;
  @track showFile = false;
  @wire(getRecord, {
      recordId: USER_ID,
      fields: [NAME_FIELD]
  }) wireuser({
      error,
      data
  }) {
      if (error) {
         this.error = error ; 
      } else if (data) {
          this.userName = data.fields.Name.value;
      }
  }


  wiredMetadataRecords;
  licenseKey;
 /* @wire( fetchJSMetadata )  
  wiredRecs( value ) {
      this.wiredMetadataRecords = value;
      const { data, error } = value;
      if ( data ) {
          this.licenseKey = data[0].Token__c;
          //console.log('>>>this.licenseKey>>>>>>>',this.licenseKey);
          this.error = undefined;
      } else if ( error ) {
          this.error = error;
          this.licenseKey = undefined;

      }

  }  */

  source = 'My file';
  fullAPI = true;
  @api recordId;

  @wire(CurrentPageReference)
  pageRef;


  connectedCallback() {
    console.log('>>>>>>>connectedCallback>>>>>>>>');
    
    this._listenForMessage = this.handleReceiveMessage.bind(this);
    const currentpageUrl = location.href;
    window.addEventListener("click", event => {
      if(currentpageUrl!= location.href)
      {
        window.removeEventListener('message', this._listenForMessage);
      }
    });
    refreshApex(this.wiredDataResult);
    window.addEventListener('message', this._listenForMessage);

   /* const currentpageUrl = location.href;
    window.addEventListener("click", event => {
      console.log('>>>>>>>Location change>>>>>>>>',location.href);
      if(currentpageUrl!= location.href)
      {
        if(this.isSaved){
          mouseinClearSetTimeFunction();
          var r = confirm("Annotations may not be saved.");
          if (r == true) {
            window.history.go(-1);
          }
          else{
            this.isSaved=false;
            return false;
          }
        }
      }
    });*/

     /*window.addEventListener('beforeunload', (event) => {
      console.log('>>>>>>beforeunload Add Event Listner>>>>>>>>>>',this.isSaved);
      if(this.isSaved){
         // mouseinClearSetTimeFunction();
          event.preventDefault();
          event.returnValue = 'Please save the File';
      }
    });*/

  }

  disconnectedCallback() {
    unregisterAllListeners(this);
    window.removeEventListener('message', this._listenForMessage);
  }

  mousein(evt){
    if(this.isSaved){
      console.log('>>>>>Mouse in>>>>>>>>');
      mouseinClearSetTimeFunction();
    }
  }
  
  mouseOut(evt) {
    console.log('mouse out event fire',this.isSaved);
    if(this.isSaved){
      mouseOutSetTimeFunction();
    }
  }

  wiredDataResult;
  
  @wire(getRelatedDocuments, { recordId: "$recordId" })
  
  document(result) {
    this.wiredDataResult = result;
    console.error('>>>>>>>>result>>>>>>',result);
    if (result.data) {
     // console.log(result.data);
      let { body, title, recordId, docId } =  result.data;
      let extension = title.substring(title.lastIndexOf('.') + 1); //get filetype from title
      const blob = new Blob([_base64ToArrayBuffer(body)], {
        type: mimeTypes[extension]
      });
      
      const payload  = {
        blob: blob,
        extension: extension,
        filename: title,
        documentId: recordId,
        docId:docId,
        taskFile:true
      };
     
      this.error = undefined;
      
      console.log('>>>>>>>>> payload in WVinstance.js',JSON.stringify(payload));
      
      setTimeout(() => {
         this.iframeWindow.postMessage({type: 'OPEN_DOCUMENT_BLOB', payload} , '*');
         this.FileLoading = false;
      }, 4000);
      
    } else if (result.error) {

      console.error('>>>>>>>>result.error>>>>>>',result.error);
      console.error('>>>>>>>>result.error body>>>>>>',result.error.body);
      console.error('>>>>>>>>result.error message>>>>>>',result.error.body.message);
      if(result.error.body.message == 'List has no rows for assignment to SObject'){
        const evt1 = new ShowToastEvent({
          title: 'Error',
          message: 'This File has been deleted. Please delete this process and create a new approval process.',
          variant: 'error',
          mode: 'dismissable'
        });
        this.dispatchEvent(evt1);
        //this.error = "This File has been deleted. Please delete this process and create a new approval process.";
      }
      else{

        const evt1 = new ShowToastEvent({
          title: 'Error',
          message: result.error.body.message,
          variant: 'error',
          mode: 'dismissable'
        });
        this.dispatchEvent(evt1);
        this.error = result.error;
      }
      //this.error = result.error;
      console.error('>>>>>>>>open document error>>>>>>>',this.error);


    }
  }

  renderedCallback() {
    var self = this;
    if (this.uiInitialized) {
        return;
    }
    this.uiInitialized = true;
    setTimeout(() => {
      Promise.all([
          loadScript(self, libUrl + '/webviewer.min.js')
      ])
      .then(() => this.initUI())
      .catch(console.error);
    }, 1000);
  }

  initUI() {
    var myObj = {
      libUrl: libUrl,
      fullAPI: this.fullAPI || false,
      namespacePrefix: '',
    };
    var url = myfilesUrl + '/webviewer-demo-annotated.pdf';

    const viewerElement = this.template.querySelector('div')
    // eslint-disable-next-line no-unused-vars
    const viewer = new PDFTron.WebViewer({
      path: libUrl, // path to the PDFTron 'lib' folder on your server
      custom: JSON.stringify(myObj),
      backendType: 'ems',
      config: myfilesUrl + '/config_apex.js',
      fullAPI: this.fullAPI,
      enableFilePicker: this.enableFilePicker,
      enableRedaction: this.enableRedaction,
      annotationUser : this.userName,
      loadAsPDF : true,
      enableMentions: true,
      disabledElements: ['fileAttachmentToolGroupButton','stampToolGroupButton','signaturePanelButton'],
     // l: this.licenseKey,
      
    }, viewerElement);

    viewerElement.addEventListener('ready', () => {
      this.iframeWindow = viewerElement.querySelector('iframe').contentWindow;
    });

  } 

  handleReceiveMessage(event) {
   // console.log('>>>>>>>>>>>>>handleReceiveMessage task>>>>>>>>>>>>>>');
    const me = this;
    if (event.isTrusted && typeof event.data === 'object') {
      console.log('>>>>>>>>>>>>>handleReceiveMessage event.data.type task>>>>>>>>>>>>>>',event.data.type);
      switch (event.data.type) {
        case 'SAVE_DOCUMENTTask':
          this.isSaved=false;
          //console.log('>>>>>>>>>>save data>>>>>>>>>>>>>>'+JSON.stringify(event.data.payload));
          saveDocument({ json: JSON.stringify(event.data.payload), recordId: this.recordId }).then((response) => {
             me.iframeWindow.postMessage({ type: 'DOCUMENT_SAVED', response }, '*')
            //this.loadSaveFinished = false;
            return refreshApex(this.wiredDataResult);
          }).catch(error => {
            console.error(JSON.stringify(error));
            const evt = new ShowToastEvent({
              title: 'Error',
              message: JSON.stringify(error.body.message),
              variant: 'error',
              mode: 'dismissable'
            });
            this.dispatchEvent(evt);
          });
          break;
          case 'saveOnMouseOut':
            console.log('>>>>>saveOnMouseOut >>>>>>>>',event.data.isSaved);
            if(event.data.isSaved===true)
            {
              this.isSaved=event.data.isSaved;
              // console.log('>>>>>saveOnMouseOut if>>>>>>>>',event.data.isSaved);
            }
          break; 
        default:
          break;
      }
    }
  }
	
	handleCallout(endpoint, token){
		fetch(endpoint,
		{
			method : "GET",
			headers : {
				"Content-Type": "application/pdf",
				"Authorization": token
			}
		}).then(function(response) {
			return response.json();
		})
		.then((myJson) =>{
			// console.log('%%%%'+JSON.stringify(myJson));
			let doc_list = [];
			for(let v of Object.values(myJson.results)){
				console.log('%%%%'+JSON.stringify(v));
				// console.log('$$$$'+v.title);
				doc_list.push();
			}
			
			// console.log('*****'+JSON.stringify(movies_list));
			
			this.documents = doc_list;
			
		})
		.catch(e=>console.log(e));
	}

  @api
  openDocument() {
    //this.iframeWindow.postMessage({ type: 'OPEN_DOCUMENT_BLOB', payload }, '*');
  }

  @api
  closeDocument() {
    this.iframeWindow.postMessage({type: 'CLOSE_DOCUMENT' }, '*')
  }
}