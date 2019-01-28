public class CLS_PortalUtils {
    public static clcommon.Response setResponse(String status, String errorCode, String errorMessage){
        clcommon.Response res = new clcommon.Response();
        res.status = status;
        res.errorCode = errorCode;
        res.errorMessage = errorMessage;
        return res;  
    }
}