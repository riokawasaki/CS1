require 'bcrypt'

class TopController < ApplicationController
    # メイン画面を表示するアクション
    def main
        # セッションにログインユーザーIDが保存されている場合
        if session[:login_uid]
            render "main" # メイン画面を表示
        else
            render "login" # ログイン画面を表示
        end
    end

    # ログイン処理を行うアクション
    def login
        # uidでユーザーを検索
        user = User.find_by(uid: params[:uid])
        
        # ユーザーが存在する場合にパスワードを検証
        if user && BCrypt::Password.new(user.pass) == params[:pass]
            session[:login_uid] = user.uid # セッションにユーザーIDを保存
            redirect_to top_main_path # メイン画面へリダイレクト
        else
            render "error", status: 422 # エラーページをステータス422で表示
        end
    end
    
    # ログアウト処理を行うアクション
    def logout
        session.delete(:login_uid) # セッションからログイン情報を削除
        redirect_to root_path # ログイン画面へリダイレクト
    end
    
    # ユーザー登録処理を行うアクション
    def signup
        # ユーザー情報を取得
        uid = params[:uid]
        password = params[:pass]
    
        # パスワードを暗号化
        encrypted_password = BCrypt::Password.create(password)
    
        # 新しいユーザーを作成
        User.create(uid: uid, pass: encrypted_password)
        redirect_to root_path # 登録後にリダイレクト
    end
    def signup_page
        render "signup" # signup.html.erbを表示
    end

end
