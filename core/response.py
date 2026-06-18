from fastapi.responses import JSONResponse

def success_response(data=None, message: str = "Success", status_code: int = 200):
    content = {
        "status": "success",
        "message": message,
        "data": data
    }
    return JSONResponse(content=content, status_code=status_code)

def error_response(message: str = "Error Occured", error: str = None, status_code: int = 500):
    content = {
        "status": "false",
        "message": message,
        "error": error
    }
    return JSONResponse(content=content, status_code=status_code)