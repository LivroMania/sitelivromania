{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handlers where
import Import
import Yesod
import Yesod.Static
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Text.Lucius

import Database.Persist.Postgresql

mkYesodDispatch "Sitio" pRoutes

widgetForm :: Route Sitio -> Enctype -> Widget -> Text -> Text -> Widget
widgetForm x enctype widget y val = do
     msg <- getMessage
     $(whamletFile "form.hamlet")
     toWidget $(luciusFile "login.lucius")
     toWidgetHead
      [hamlet|
     <link href=@{FaviconR} rel="shortcut icon" sizes="32x32" type="img/ico" />
        |]

-- widget de cadastro de usuario
widgetFormCad :: Route Sitio -> Enctype -> Widget-> Text -> Text -> Widget
widgetFormCad  x enctype widget y val = do
    msg <- getMessage
    $(whamletFile "cadastro.hamlet")
    toWidget $(luciusFile "cadastro.lucius")
    toWidgetHead
      [hamlet|
    <link href=@{FaviconR} rel="shortcut icon" sizes="32x32" type="img/ico" />
        |]

-- so precisa do entype e do widget e o retorno do ultimo widget
widgetFormLiv :: Route Sitio -> Enctype -> Widget-> Text -> Text -> Widget
widgetFormLiv  x enctype widget y val = do
    msg <- getMessage
    $(whamletFile "livro.hamlet")
    toWidget $(luciusFile "avaliar.lucius")
    toWidgetHead
      [hamlet|
    <link href=@{FaviconR} rel="shortcut icon" sizes="32x32" type="img/ico" />
        |]

widgetFormAvaliar :: Route Sitio -> Enctype -> Widget -> Text -> Text -> Widget
widgetFormAvaliar  x enctype widget y val = do
    msg <- getMessage
    $(whamletFile "avaliar.hamlet")
    toWidget $(luciusFile "avaliar.lucius")
    toWidgetHead
      [hamlet|
    <link href=@{FaviconR} rel="shortcut icon" sizes="32x32" type="img/ico" />
        |]

formAv ::  Form Avaliacao
formAv  = renderDivs $ Avaliacao <$>
    areq intField "Nota" Nothing <*> 
    areq (selectField us) "Usuario:" Nothing <*>
    areq (selectField lv) "Livro:" Nothing <*>
    areq textField "Avaliação: " Nothing


us = do
    entidades <- runDB $ selectList [] [Asc UsuarioNome]
    optionsPairs $ fmap(\ent -> (usuarioNome $ entityVal ent, entityKey ent)) entidades
lv = do
    entidades <- runDB $ selectList [] [Asc LivroNm_Livro]
    optionsPairs $ fmap(\ent -> (livroNm_Livro $ entityVal ent, entityKey ent)) entidades

formLiv :: Form Livro
formLiv = renderDivs $ Livro  <$>
    areq textField "Codigo ISBN:" Nothing <*>
    areq textField "Titulo:" Nothing <*>
    areq textField "Autor:" Nothing <*>
    areq textField "Ano:" Nothing <*>
    areq textField "Genero:" Nothing <*>
    pure 0 <*>
    areq textField "Sinopse:" Nothing


formUsu :: Form Usuario
formUsu = renderDivs $ Usuario <$>
    areq textField "Login:" Nothing <*>
    areq passwordField "Senha:" Nothing <*>
    pure ""

formCad :: Form Usuario
formCad = renderDivs $ Usuario <$>
    areq textField "Login:" Nothing <*>
    areq textField "Senha:" Nothing <*>
    areq textField "Nome: " Nothing

getListaDeAvR :: Handler Html
getListaDeAvR = do
    ordens <- runDB $ selectList [] [Asc LivroNm_Livro]
    defaultLayout $ toWidgetHead
        [hamlet|
    <link href=@{FaviconR} rel="shortcut icon" sizes="32x32" type="img/ico" />
        |] >> $(whamletFile "avaliacao.hamlet")  >> toWidget $(luciusFile "teste.lucius")

getVisAvaR :: Key Livro -> Handler Html
getVisAvaR x = do
    liAv <- runDB $ selectList [AvaliacaoCd_Livro ==. x] []
    defaultLayout $ toWidgetHead
        [hamlet|
    <link href=@{FaviconR} rel="shortcut icon" sizes="32x32" type="img/ico" />
        |] >> $(whamletFile "visavar.hamlet")--  >> toWidget $(luciusFile "teste.lucius")
    

getFaviconR :: Handler Html
getFaviconR = sendFile "img/ico" "favicon.ico"

getListLivR :: Handler Html
getListLivR = do
    liU <- runDB $ selectList [] [Asc LivroNm_Livro]
    defaultLayout $ toWidgetHead
        [hamlet|
    <link href=@{FaviconR} rel="shortcut icon" sizes="32x32" type="img/ico" />
        |] >> $(whamletFile "livros.hamlet") >> toWidget $(luciusFile "teste.lucius")


getVisualizarR :: Key Livro -> Handler Html
getVisualizarR x = do
    liU <- runDB $ selectFirst [LivroId ==. x] []
    defaultLayout $ toWidgetHead
        [hamlet|
    <link href=@{FaviconR} rel="shortcut icon" sizes="32x32" type="img/ico" />
        |] >> $(whamletFile "listalivros.hamlet")-- >> toWidget $(luciusFile "teste.lucius")
  
    
getAvaliarR :: Handler Html
getAvaliarR = do
    (wid,enc) <- generateFormPost formAv
    defaultLayout $ widgetFormAvaliar AvaliarR enc wid "Avalie um de nossos livros" "Avaliar"
    
postAvaliarR :: Handler Html
postAvaliarR = do
    ((result,_),_) <- runFormPost formAv
    case result of
        FormSuccess cadliv -> do
            runDB $ insert cadliv
            setMessage $ [shamlet| <p> Obrigado por Avaliar o Livro! |]
            redirect AvaliarR
        _ -> redirect AvaliarR
getLivroR :: Handler Html
getLivroR = do
    (wid,enc) <- generateFormPost formLiv
    defaultLayout $ widgetFormLiv LivroR enc wid "Preencha os campos para cadastrar um novo livro" "Cadastrar"

postLivroR :: Handler Html
postLivroR = do
    ((result,_),_) <- runFormPost formLiv
    case result of
        FormSuccess cadliv -> do
            runDB $ insert cadliv
            setMessage $ [shamlet| <p> Livro inserido com sucesso! |]
            redirect LivroR
        _ -> redirect LivroR
        
-- esta modificado para cadastrar o usuario em outro form/codigo html, esta ok!
getUsuarioR :: Handler Html
getUsuarioR = do
    (wid,enc) <- generateFormPost formCad
    defaultLayout $ widgetFormCad UsuarioR enc wid "Começe ja a usar o LivroMania" "Cadastrar"

--getImgR :: Handler Html
--getImgR = defaultLayout
        
getWelcomeR :: Handler Html
getWelcomeR = do
     usr <- lookupSession "_ID"
     defaultLayout $ toWidgetHead
        [hamlet|
     <link href=@{FaviconR} rel="shortcut icon" sizes="32x32" type="img/ico" />
        |] >> $(whamletFile "inicio.hamlet")--  >> toWidget $(luciusFile "teste.lucius")
     
     
     
     


getLoginR :: Handler Html
getLoginR = do
    (wid,enc) <- generateFormPost formUsu
    defaultLayout $ widgetForm LoginR enc wid "Digite seus dados para acessar o LivroMania" "Entrar"
    


postLoginR :: Handler Html
postLoginR = do
    ((result,_),_) <- runFormPost formUsu
    case result of
        FormSuccess usr -> do
            usuario <- runDB $ selectFirst [UsuarioNome ==. usuarioNome usr, UsuarioPass ==. usuarioPass usr ] []
            case usuario of
                Just (Entity uid usr) -> do
                    setSession "_ID" (usuarioNome usr)         
                    redirect WelcomeR
                Nothing -> do
                    setMessage $ [shamlet| <br> Usuário ou senha incorretos |]
                    redirect LoginR 
        _ -> redirect LoginR

postUsuarioR :: Handler Html
postUsuarioR = do
    ((result,_),_) <- runFormPost formUsu
    case result of
        FormSuccess usr -> do
            runDB $ insert usr
            setMessage $ [shamlet| <p> Usuario inserido com sucesso! |]
            redirect UsuarioR
        _ -> redirect UsuarioR

getListUserR :: Handler Html
getListUserR = do
    listaU <- runDB $ selectList [] [Asc UsuarioNome]
    defaultLayout $(whamletFile "list.hamlet")

getByeR :: Handler Html
getByeR = do
    deleteSession "_ID"
    redirect LoginR

getSobreR :: Handler Html
getSobreR = do
    defaultLayout $(whamletFile "sobre.hamlet")




connStr = "dbname=dbj6e5o0khrri7 host=ec2-54-227-254-13.compute-1.amazonaws.com user=pxytleypkfkrfw password=INxCUYCgxZtr88fumSX2JdSzBn port=5432"

main::IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do
       runSqlPersistMPool (runMigration migrateAll) pool
       s <- static "."
       warpEnv (Sitio pool s)