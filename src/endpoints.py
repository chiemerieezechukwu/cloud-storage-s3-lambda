from lambda_router.response import Response, status

from config import app, s3_manager


@app.route("/")
@app.route("/index")
def index(request):
    response = {"original_event": request.event}
    return Response(status.HTTP_200_OK, response)


@app.route("/get_presigned_url")
def get_presigned_url(request):
    response = s3_manager.get_presigned_url(request)
    return Response(status.HTTP_200_OK, response)


@app.route("/get_presigned_post", methods=["POST"])
def get_presigned_post(request):
    response = s3_manager.get_presigned_post(request)
    return Response(status.HTTP_200_OK, response)


@app.route("/delete_object", methods=["DELETE"])
def delete_object(request):
    s3_manager.delete_object(request)
    return Response(status.HTTP_204_NO_CONTENT)
