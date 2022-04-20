from lambda_router.exceptions import Exception404, Exception405, Exception500
from lambda_router.response import Response, status

from config import app
from custom_logger import logger

logger.debug(f"Registered routes and methods: {app.list_routes()}")


@logger.inject_lambda_context(log_event=True)
def lambda_handler(event, context):
    try:
        _ret: Response = app.run(event, context)
        res = _ret.build()
        logger.debug(f"Response: {res}")
    except (Exception404, Exception405, Exception500) as e:
        logger.exception(e)
        res = Response(e.STATUS_CODE, e.args).build()
    except Exception as e:
        logger.exception(e)
        res = Response(status.HTTP_500_INTERNAL_SERVER_ERROR, e.args).build()
    return res


# Remove the following line when you are done with the development
###############################################################################
if __name__ == "__main__":
    import json
    from unittest.mock import Mock

    with open("example_lambda_url_event.json", "r") as f:
        data = f.read()
    event = json.loads(data)
    print(lambda_handler(event, Mock()))
###############################################################################
