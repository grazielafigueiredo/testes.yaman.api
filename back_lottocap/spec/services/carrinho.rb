# frozen_string_literal: true

require "utils/constant"
require "services/user"



class ApiCarrinho
    include HTTParty
    base_uri "https://hmlapi.lottocap.com.br/api/Carrinho"
    headers "Content-Type" => "application/json"  
    


    def self.get_GetStatusCarrinho()
        # headers[:Authorization] = token

        res = get("/GetStatusCarrinho")
        # return res[obj][0][idCarrinho]
    end

    #Enviar quantidade além da permitida
    def self.post_SetQtdItemCarrinho(qtdItens, token)
            headers[:Authorization] = token

            
            @SetQtdItemCarrinho = { "obj": {
                "novaQtdItem": qtdItens, 
                "idSerie": Constant::IdSerie,
                "flPromoAtiva": false },
                "atualPagina": 1,
                "tamanhoPagina": 999 }        
        
        
        post("/SetQtdItemCarrinho", body: @SetQtdItemCarrinho.to_json)
    end

    def self.post_AdicionarItemCarrinho(qtdItens, token)
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

    def self.post_AdicionarItemCarrinho87(qtdItens, token)
        headers['Authorization'] = token

        @AdicionarItemCarrinho87 = { 
            "obj": {
                "idCarrinho": 0,
                "idProduto": Constant::IdProduto,
                "idSerie": Constant::IdSerie87,
                "qtdItens": qtdItens, 
                "flPromoAtiva": false
                },
                "atualPagina": 1,
                "tamanhoPagina": 999
            }
        post("/AdicionarItemCarrinho", body: @AdicionarItemCarrinho87.to_json)
    end


    def self.post_SetRemoverItemCarrinho(token, idCarrinho)
        headers['Authorization'] = token


        @SetRemoverItemCarrinho = {
            "obj": {
                "idCarrinhoItem": idCarrinho,
                "flPromoAtiva": false
            },
            "atualPagina": 1,
            "tamanhoPagina": 999
        }
        post("/SetRemoverItemCarrinho", body: @SetRemoverItemCarrinho.to_json)
    end

end



