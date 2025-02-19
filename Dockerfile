FROM python:3.11-buster AS builder

#set working path
WORKDIR /app

#install poetry and upgrade pip
RUN pip install --upgrade pip && pip install poetry

#copy code to builder stage
COPY . .

#configure poetry
RUN poetry config virtualenvs.create false \
 && poetry install --no-root --no-interaction --no-ansi

#Beginning of app stage
FROM python:3.11-buster AS app

#set working path
WORKDIR /app

#Copy code from directory in builder stage to the app stage
COPY --from=builder /app /app

#expose port 8000
EXPOSE 8000

#set entrypoint
#RUN chmod +x entrypoint.sh
#ENTRYPOINT ["./entrypoint.sh"]

ENV PATH=$PATH:/app/.venv/bin
CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
