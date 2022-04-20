FROM public.ecr.aws/lambda/python:3.7

COPY src /var/task

RUN pip install -r requirements.txt -t /var/task

CMD [ "lambda_function.lambda_handler" ]
