# frozen_string_literal: true

require "utils/constant"
require "services/user"



class ApiCarrinho
    include HTTParty
    base_uri Constant::Url
    headers "Content-Type" => "application/json", 'Authorization' => ApiUser.GetToken  
    


    def self.get_GetStatusCarrinho
        get("/Carrinho/GetStatusCarrinho")
    end

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

    # def self.post_adicionarItemCarrinho(qtdItens, idProduto, idSerie, token)
    #     headers['Authorization'] = token

    #     @adicionarItemCarrinho = 
    #     # { 
    #     #     "obj": {
    #     #         "idCarrinho": 0,
    #     #         "idProduto": idProduto,
    #     #         "idSerie": idSerie,
    #     #         "qtdItens": qtdItens 
    #     #         # "flPromoAtiva": false
    #     #         },
    #     #         "atualPagina": 1,
    #     #         "tamanhoPagina": 999
    #     #     }
    #     {
    #         "obj": {
    #             "idCarrinho": 0,
    #             "idProduto": idProduto,
    #             "idSerie": idSerie,
    #             "qtdItens": qtdItens
    #         },
    #         "atualPagina": 1,
    #         "tamanhoPagina": 999
    #     }
    #     post("/Carrinho/AdicionarItemCarrinho", body: @adicionarItemCarrinho.to_json)
    # end
    def self.post_add_item_cart(token, cart)
        headers['Authorization'] = token
        cart[:qtdItens] = 1
        payload = { "obj": cart }
        post("/Carrinho/AdicionarItemCarrinho", body: payload.to_json)
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

    def self.post_adicionarItemCarrinhoAfiliados(token, idProduto, idSerie87, qtdItens)
        headers['Authorization'] = token

        @adicionarItemCarrinhoAfiliados = 
        {
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
        post("/Carrinho/AdicionarItemCarrinhoAfiliados", body: @adicionarItemCarrinhoAfiliados.to_json)
    end

    def self.post_GetCarrinhoItens(token)
        headers['Authorization'] = token
       
        @GetCarrinhoItens = {
            "obj": {
                "flPromoAtiva": false
            }
        }

        post("Carrinho/GetCarrinhoItens", body: @GetCarrinhoItens.to_json)
    end
end



