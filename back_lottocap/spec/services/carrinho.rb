# frozen_string_literal: true

require "utils/constant"
require "services/user"



class ApiCarrinho
    include HTTParty
    base_uri Constant::Url
    headers "Content-Type" => "application/json"  
    


    def self.get_GetStatusCarrinho()
        # headers[:Authorization] = token

        get("/Carrinho/GetStatusCarrinho")
        # return res[obj][0][idCarrinho]
    end

    #Enviar quantidade além da permitida
    def self.post_SetQtdItemCarrinho(qtdItens, token, idSerie)
            headers[:Authorization] = token

            
            @SetQtdItemCarrinho = { "obj": {
                "novaQtdItem": qtdItens, 
                "idSerie": idSerie,
                "flPromoAtiva": false },
                "atualPagina": 1,
                "tamanhoPagina": 999 }        
        
        
        post("/Carrinho/SetQtdItemCarrinho", body: @SetQtdItemCarrinho.to_json)
    end

    def self.post_AdicionarItemCarrinho(qtdItens, idProduto, idSerie, token)
        headers['Authorization'] = token

        @AdicionarItemCarrinho = { 
            "obj": {
                "idCarrinho": 0,
                "idProduto": idProduto,
                "idSerie": idSerie,
                "qtdItens": qtdItens, 
                "flPromoAtiva": false
                },
                "atualPagina": 1,
                "tamanhoPagina": 999
            }
        post("/Carrinho/AdicionarItemCarrinho", body: @AdicionarItemCarrinho.to_json)
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
        post("/Carrinho/SetRemoverItemCarrinho", body: @SetRemoverItemCarrinho.to_json)
    end

    def self.post_AdicionarItemCarrinhoAfiliados(idProduto, idSerie87, qtdItens, token)
        headers['Authorization'] = token

        @AdicionarItemCarrinhoAfiliados = {
            "obj": {
                "idCarrinho": 0,
                "idProduto": idProduto, #neste endpoint o front ignora a id série
                "idSerie": idSerie87, 
                "qtdItens": qtdItens,
                "flPromoAtiva": false
            },
            "atualPagina": 1,
            "tamanhoPagina": 999
        }
        post("/Carrinho/AdicionarItemCarrinhoAfiliados", body: @AdicionarItemCarrinhoAfiliados.to_json)
    end
end



