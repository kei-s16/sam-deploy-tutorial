import { DynamoDBClient, PutItemCommand } from '@aws-sdk/client-dynamodb'
import { v4 as uuidv4 } from 'uuid';

const AWS_LAMBDA_REGION = process.env.AWS_LAMBDA_REGION;
const AWS_DYNAMODB_ENDPOINT = process.env.AWS_DYNAMODB_ENDPOINT;
const AWS_DYNAMODB_TABLE = process.env.AWS_DYNAMODB_TABLE;

const config = {
  endpoint: AWS_DYNAMODB_ENDPOINT,
  region: AWS_LAMBDA_REGION,
}

const dynamodb = new DynamoDBClient(config);

export const lambdaHandler = async (event, context) => {
    const body = JSON.parse(event.body);

    try {
        const command = new PutItemCommand({
            TableName: AWS_DYNAMODB_TABLE,
            Item: {
              uuid: { S: uuidv4() },
              todo: { S: body.todo },
            },
        });
        const result = await dynamodb.send(command);
        console.log(result);
        return {
            'statusCode': 200,
            'body': JSON.stringify({
                message: result,
            })
        }
    } catch (err) {
        console.log(err);
        return err;
    }
};
