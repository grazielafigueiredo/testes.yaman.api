require 'utils/constant'



class ApiUser
    include HTTParty
    base_uri Constant::Url
    headers "Content-Type" => "application/json"

    # def self.find()
    #     # headers[:Authorization] = self.GetToken()
        
    #     @user = {"obj": {"usuario": "user22@gmail.com", "senha": "1234"}}

    #     response_in_json = JSON.parse(get("/Usuario/GerarToken").response.body)
    #     token = response_in_json['dadosUsuario']['token']


    #     headers[:Authorization] = token
    #     post("/Usuario/LogarUsuario", body: @user.to_json, :headers => headers)

    #     return token

    # end

    def self.Login(token, user)
        @user = {"obj": user}

        headers[:Authorization] = token
        
        post("/Usuario/LogarUsuario", body: @user.to_json, :headers => headers)
    end

    def self.GetToken()
        response_in_json = JSON.parse(get("/Usuario/GerarToken").response.body)

        token = response_in_json['obj'][0]['token'] 
    
        return token
    end

    def self.get_deslogar(token)
        headers[:Authorization] = token

        get("/Usuario/DeslogarUsuario", :headers => headers)
    end
end

# class Token
#     include Singleton

#     def initialize()
#         @token = ApiUser.GetToken()
#     end

#     def get()
#         return @token
#     end
# end
