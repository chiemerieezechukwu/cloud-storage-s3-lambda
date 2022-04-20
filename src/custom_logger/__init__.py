from aws_lambda_powertools import Logger

logger = Logger(
    __name__,
    level="DEBUG",
    location="function=%(module)s.%(funcName)s path=%(pathname)s:%(lineno)d pid=%(process)d tid=%(thread)d",
)
