package main

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Response struct {
	Method  string `json:"method"`
	Message string `json:"message"`
}

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var res Response

	switch req.HTTPMethod {
	case "GET":
		res = Response{Method: "GET", Message: "GET request received"}
	case "POST":
		res = Response{Method: "POST", Message: fmt.Sprintf("POSTed data: %s", req.Body)}
	case "PUT":
		res = Response{Method: "PUT", Message: fmt.Sprintf("PUT data: %s", req.Body)}
	case "DELETE":
		res = Response{Method: "DELETE", Message: "DELETE request received"}
	default:
		return events.APIGatewayProxyResponse{
			StatusCode: 405,
			Body:       "Method Not Allowed",
		}, nil
	}

	body, _ := json.Marshal(res)
	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers:    map[string]string{"Content-Type": "application/json"},
		Body:       string(body),
	}, nil
}

func main() {
	lambda.Start(handler)
}
