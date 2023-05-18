

class Headers {
  httpHeadersWithoutToken() {
    return {
      'Content-type': 'application/json',
    };
  }

  httpHeadersWithToken(String token)  {
    
    return {"Content-Type": "application/json", "Token": token};
  }
}
