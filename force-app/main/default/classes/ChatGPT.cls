public with sharing class ChatGPT {
    public static final String BASE_URL = 'https://api.openai.com/v1/';
    
    public static String listModels() {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:ChatGPTLegacy/v1/models');
        // System.debug('Endpoint: ' + req.getEndpoint());
        req.setHeader('OpenAI-Organization', '{!$Credential.Username}');
        // System.debug('OpenAI-Organization header: ' + req.getHeader('OpenAI-Organization'));
        req.setHeader('Authorization', 'Bearer {!$Credential.Password}');
        // System.debug('Authorization header: ' + req.getHeader('Authorization'));
        
        HttpResponse resp = new Http().send(req);
        System.debug(resp.getBody());
        return resp.getBody();
    }
    
    public static String createImage(String prompt) {
        ImageRequest imgReq = new ImageRequest();
        imgReq.prompt = prompt;
        imgReq.n = 1;
        imgReq.size = '1024x1024';
        // imgReq.response_format = 'url';
        imgReq.response_format = 'b64_json';
        return createImage(imgReq);
    }
    
    public static String createImage(ImageRequest imgReq) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('callout:ChatGPTLegacy/v1/images/generations');
        // System.debug('Endpoint: ' + req.getEndpoint());
        req.setHeader('OpenAI-Organization', '{!$Credential.Username}');
        // System.debug('OpenAI-Organization header: ' + req.getHeader('OpenAI-Organization'));
        req.setHeader('Authorization', 'Bearer {!$Credential.Password}');
        // System.debug('Authorization header: ' + req.getHeader('Authorization'));
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(imgReq));
        
        HttpResponse resp = new Http().send(req);
        System.debug(resp.getBody());
        return resp.getBody();
    }
    
    public static List<ContentVersion> saveImages(String imageResultJson) {
        ImageResult imgRes = (ImageResult)JSON.deserialize(imageResultJson, ImageResult.class);
        List<Image> images = imgRes.data;
        
        
        // Create ContentVersions and insert into Salesforce
        List<ContentVersion> imagesToSave = new List<ContentVersion>();
        for(Integer idx = 0; idx < images.size(); idx++) {
            ContentVersion contVer = new ContentVersion();
            contVer.VersionData = EncodingUtil.base64decode(images[idx].b64_json);
            contVer.Title = 'image' + String.valueOf(idx) + '.png';
            contVer.ContentLocation = 's';
            contVer.PathOnClient = 'image' + String.valueOf(idx) + '.png';
            imagesToSave.add(contVer);
        }
        insert imagesToSave;
        
        return imagesToSave;
    }
    
    public static List<Database.SaveResult> insertModels(String resultJson) {
        ModelResult result = (ModelResult)JSON.deserialize(resultJson, ModelResult.class);
        System.debug(result);
        List<Model> modelList = result.data;
        List<Model__c> modelSObjects = new List<Model__c>();
        for(Model m : modelList) {
            modelSObjects.add(new Model__c(
                Name = m.id
            ));
        }
        List<Database.SaveResult> saveResults = Database.insert(modelSObjects);
        return saveResults;
    }
    
    public class ModelResult {
        // Not able to use Apex class deserialization for reserved word "object"
        // public String object {get; set;}
        public List<Model> data {get; set;}
    }
    
    public class Model {
        public String id {get; set;}
    }
    
    public class ImageRequest {
        public String prompt {get; set;}
        public Integer n {get; set;}
        public String size {get; set;}
        public String response_format {get; set;}
    }
    
    public class ImageResult {
        public Integer created {get; set;}
        public List<Image> data {get; set;}
    }
    
    public class Image {
        public String url {get; set;}
        public String b64_json {get; set;}
    }
}