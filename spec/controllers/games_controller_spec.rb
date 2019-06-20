require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'GET /games/:id' do
    let(:game) do
      create(
        :game,
        board: ['S', 'O', 'P', '*', 'E', 'B', 'K', 'S', 'A', 'B', 'R', 'S', 'S', '*', 'X', 'D'],
        duration: 150
      )
    end

    context 'with correct :id' do
      it 'returns information about the game' do
        get :show, params: { id: game.id }

        expect(response.status).to eq(200)
        expect(json(response.body)[:id]).to eq(game.id)
        expect(json(response.body)[:token]).to eq(game.token)
        expect(json(response.body)[:points]).to eq(game.points)
        expect(json(response.body)[:duration]).to eq(game.duration)
        expect(json(response.body)[:time_left]).to eq(game.time_left)
        expect(json(response.body)[:board]).to eq(game.board.join(', '))
      end
    end

    context 'with wrong :id' do
      it 'returns 404 error' do
        get :show, params: { id: -1 }

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST /games' do
    context 'with correct params' do
      it 'successfully creates game with the random board' do
        params = { random: true, duration: 500 }
        post :create, params: params, as: :json

        expect(response.status).to eq(201)
        expect(json(response.body)[:duration]).to eq(params[:duration])
      end

      it 'successfully creates game with the defined board' do
        params = { random: false, board: 'A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q',  duration: 600 }
        post :create, params: params, as: :json

        expect(response.status).to eq(201)
        expect(json(response.body)[:duration]).to eq(params[:duration])
        expect(json(response.body)[:board]).to eq(params[:board])
      end

      it 'successfully creates game with the default board' do
        params = { random: false, duration: 700 }
        post :create, params: params, as: :json

        expect(response.status).to eq(201)
        expect(json(response.body)[:duration]).to eq(params[:duration])
        expect(json(response.body)[:board]).to eq(Boggle::Board.default.flatten.join(', '))
      end
    end

    context 'with wrong params' do
      it 'throws an error if duration param is missing' do
        params = { random: true }
        post :create, params: params, as: :json

        expect(response.status).to eq(400)
      end

      it 'throws an error if random param is missing' do
        params = { duration: 150 }
        post :create, params: params, as: :json

        expect(response.status).to eq(400)
      end
    end
  end

  describe 'PUT /games/:id' do
    let(:game) do
      create(
        :game,
        board: ['S', 'H', 'P', '*', 'E', 'I', 'K', 'S', 'A', 'B', 'R', 'S', 'S', '*', 'X', 'D'],
        duration: 10
      )
    end

    context 'with correct params' do
      context 'when word guessed' do
        it 'successfully updates the game' do
          word = 'ship'
          params = { id: game.id, word: word, token: game.token }
          put :update, params: params, as: :json

          expect(response.status).to eq(200)
          expect(json(response.body)[:id]).to eq(game.id)
          expect(json(response.body)[:token]).to eq(game.token)
          expect(json(response.body)[:points]).to eq(game.points + word.length)
          expect(json(response.body)[:duration]).to eq(game.duration)
          expect(json(response.body)[:time_left]).to eq(game.time_left)
          expect(json(response.body)[:board]).to eq(game.board.join(', '))
        end
      end

      context 'when word cannot be obtained from board' do
        it 'throws an error' do
          word = 'acrostic'
          params = { id: game.id, word: word, token: game.token }
          put :update, params: params, as: :json

          expect(response.status).to eq(400)
        end
      end

      context 'when word is not from the dictionary' do
        it 'throws an error' do
          word = 'worddonotexist'
          params = { id: game.id, word: word, token: game.token }
          put :update, params: params, as: :json

          expect(response.status).to eq(400)
        end
      end

      context 'when word was already used' do
        it 'throws an error' do
          word = 'box'
          params = { id: game.id, word: word, token: game.token }
          put :update, params: params, as: :json

          expect(response.status).to eq(200)

          put :update, params: params, as: :json

          expect(response.status).to eq(400)
        end
      end
    end

    context 'with wrong params' do
      context 'when game token missing' do
        it 'throws an error' do
          word = 'acrostic'
          old_points = game.points

          params = { id: game.id, word: word }
          put :update, params: params, as: :json

          new_points = game.reload.points

          expect(response.status).to eq(400)
          expect(new_points).to eq(old_points)
        end
      end

      context 'when word includes wrong symbols' do
        it 'throws an error' do
          word = 'p*ss'
          old_points = game.points

          params = { id: game.id, word: word, token: game.token }
          put :update, params: params, as: :json

          new_points = game.reload.points

          expect(response.status).to eq(400)
          expect(new_points).to eq(old_points)
        end
      end
    end
  end
end
