# frozen_string_literal: true

require "utils/constant"
require "services/user"



class ApiCarrinho
    include HTTParty
    base_uri "https://hmlapi.lottocap.com.br/api/Carrinho"
    headers "Content-Type" => "application/json"  , 'Authorization' => Constant::Authorization
    
    # def initialize( token )
    #     @token = token
    # end

    #login
    def self.get_GetStatusCarrinho()
        # headers[:Authorization] = token

        res = get("/GetStatusCarrinho")
        # return res[obj][0][idCarrinho]
    end

    #Enviar quantidade além da permitida
    def self.post_SetQtdItemCarrinho(qtdItens)
            
            
            @SetQtdItemCarrinho = { "obj": {
                "novaQtdItem": qtdItens, 
                "idSerie": Constant::IdSerie,
                "flPromoAtiva": false },
                "atualPagina": 1,
                "tamanhoPagina": 999 }        
        
        
        post("/SetQtdItemCarrinho", body: @SetQtdItemCarrinho.to_json)
    end

    
    def self.post_AdicionarItemCarrinho(qtdItens)

        @AdicionarItemCarrinho = { 
            "obj": {
                "idCarrinho": Constant::IdCarrinho,
                "idProduto": Constant::IdProduto,
                "idSerie": Constant::IdSerie,
                "qtdItens": qtdItens, 
                "flPromoAtiva": false
                },
                "atualPagina": 1,
                "tamanhoPagina": 999
            }
        post("/AdicionarItemCarrinho", body: @AdicionarItemCarrinho.to_json)
    end

    def self.post_AdicionarItemCarrinhoParametrizado(token, qtdItens)
        headers['Authorization'] = token

        @AdicionarItemCarrinho = { 
            "obj": {
                "idCarrinho": 0,
                "idProduto": Constant::IdProduto,
                "idSerie": Constant::IdSerie,
                "qtdItens": qtdItens, 
                "flPromoAtiva": false
                },
                "atualPagina": 1,
                "tamanhoPagina": 999
            }
        post("/AdicionarItemCarrinho", body: @AdicionarItemCarrinho.to_json)
    end



    def self.post_SetRemoverItemCarrinho()

        @SetRemoverItemCarrinho = {
            "obj": {
                "idCarrinhoItem": Constant::IdCarrinho,
                "flPromoAtiva": false
            },
            "atualPagina": 1,
            "tamanhoPagina": 999
        }
        post("/SetRemoverItemCarrinho", body: @SetRemoverItemCarrinho.to_json)
    end

end



