FROM public.ecr.aws/lambda/python:3.8
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
RUN chmod 644 *.py && chmod -R +r .
CMD ["lambda_function.lambda_handler"]