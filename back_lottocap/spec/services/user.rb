


class ApiUser
    include HTTParty
    base_uri "https://hmlapi.lottocap.com.br/api/"
    headers "Content-Type" => "application/json"

    def self.find()
        # headers[:Authorization] = self.GetToken()
        
        @user = {"obj": {"usuario": "user1@gmail.com", "senha": "1234"}}

        response_in_json = JSON.parse(get("/Usuario/GerarToken").response.body)
        token = response_in_json['dadosUsuario']['token']


        headers[:Authorization] = token
        post("/Usuario/LogarUsuario", body: @user.to_json, :headers => headers)

        return token

    end

    def self.GetToken()
        response_in_json = JSON.parse(get("/Usuario/GerarToken").response.body)

        token = response_in_json['dadosUsuario']['token']
        puts "New Token"
        puts token
        return token
    end

    def self.get_deslogar
        get("/Usuario/DeslogarUsuario")
    end
end

class Token
    include Singleton

    def initialize()
        @token = ApiUser.GetToken()
    end

    def get()
        return @token
    end
end
