classdef TicTacToe < handle

    properties
        robot = [];
        X = 10;
        O = 100;
        playingAs = 100; %default robot = X
        user = 10;
        board = zeros(3,3);
    end

    methods (Access = private)
        

        function result = isWinner(obj, val)
            row_sum = sum(obj.board, 1);
            col_sum = sum(obj.board, 2);
            diag_sum1 = trace(obj.board);
            diag_sum2 = obj.board(1, 3) + obj.board(2, 2) + obj.board(3, 1);
            res_row_col = any(ismember(row_sum, 3*val)) || any(ismember(col_sum, 3*val));
            res_diag = (diag_sum1 == 3*val) || (diag_sum2 == 3*val);
            result = res_diag || res_row_col;      
        end

        

        function best = minimax(obj, depth, isMax)
            [~, ~, score] = obj.checkForWin();

            if score == 10
                best = score;
                return;
            end
            
            if score == -10
                best = score;
                return;
            end

            if (obj.isMoveLeft() == false)
                best = 0;
                return;
            end
            
            if isMax
                best = -1000;

                for i=1:3
                    for j=1:3
                        if (obj.board(i,j) == 0)
                            obj.board(i,j) = obj.playingAs;
                            best = max(best, obj.minimax(depth+1, ~isMax));
                            obj.board(i,j) = 0;
                        end   
                    end
                end
            else
                best = 1000;

                for i=1:3
                    for j=1:3
                        if (obj.board(i,j) == 0)
                            obj.board(i,j) = obj.user;
                            best = min(best, obj.minimax(depth+1, ~isMax));
                            obj.board(i,j) = 0;
                        end
                        
                    end
                end
            end
        end
        

    end

    methods (Access = public)

        function obj = TicTacToe(robot)
            obj.robot = robot;
        end

        function [res, winner, val] = checkForWin(obj)

            if obj.isWinner(obj.X)
                res = true;
                winner = obj.X;
                if obj.playingAs == obj.X
                    val = 10;
                else
                    val = -10;
                end
            elseif obj.isWinner(obj.O)
                res = true;
                winner = obj.O;
                if obj.playingAs == obj.O
                    val = 10;
                else
                    val = -10;
                end
            else
                winner = 0;
                val = 0;
                res = false;
            end
        end

        function result = isMoveLeft(obj)
            result = false;
            for i=1:3
                for j=1:3
                    if obj.board(i,j) == 0
                        result = true;
                    end
                end
            end   
        end


        function square = ComputeNextMove(obj)
            square = [-1, -1];
            best = -1000;
            for i=1:3
                for j=1:3
                    if obj.board(i,j) == 0
                        obj.board(i,j) = obj.playingAs;

                        currVal = obj.minimax(0, false);

                        obj.board(i,j) = 0;

                        if currVal > best
                            best = currVal;
                            square = [i, j];
                        end
                    end
                end
            end
        end
    end

end