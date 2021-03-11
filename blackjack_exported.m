% Script File - Project 3
%
% Names: Camron Avent and Maria Babcock
% Course: EGR115, Section 3, Fall 2019
% Project 3 - Blackjack Game
%
% Description:
%   This program is a simplified version of the card game Blackjack. The 
%   goal of blackjack is to beat the dealer's hand without going over 21.
%   Face cards are worth 10. Aces are worth 1 or 11, whichever makes the 
%   better hand. The player starts with two cards, one of the dealer's
%   cards is hidden until the end. To 'Hit' is to ask for another card. To
%   'Stand' is to hold your total and end your turn. If you go over 21 you 
%   bust, and the dealer wins regardless of the dealer's hand. If you are 
%   dealt 21, you got a blackjack and win. If your hand is closer to 21
%   than the dealers you win. The rules of double down and split are not 
%   included in this version of blackjack This program allows you to make 
%   bets and try and make as much money as possible. It also shows your 
%   statistics throughout the game.
%
% Variable Definitions:
%   Deck = 1:52 matrix for deck of cards
%   indexPlayer = index of what card to show for player
%   indexDealer = index of what car to show for dealer
%   playerVal = value of players hand
%   dealerVal = value of dealers hand
%   bet = bet amount
%   money = total amount of player money
%   a = first card value for player
%   b = second card value for player
%   c = every card value for player from a hit
%   x = first card value for dealer 
%   y = second card value for dealer
%   z = every card value for dealer from a hit
%   wins = number of wins
%   losses = number of losses 
%   pushes = number of pushes
%   blackjacks = number of blackjacks 
%   cardStr = The file name for the images of the cards in the txt file
%   cardVal = Value of the card based off the txt file  
%   audioFile, w, Fs, audioFile1, g, Gs = variables used for playing audio 
%   cardIndex = Random index of card to pick from deck
%   dres = Result of dealers hand
%   pres = Result of players hand
%   

classdef blackjack_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        backgroundImg     matlab.ui.control.Image
        hitButton         matlab.ui.control.Button
        standButton       matlab.ui.control.Button
        dealButton        matlab.ui.control.Button
        betButton         matlab.ui.control.Button
        chipsImg          matlab.ui.control.Image
        playerCard1       matlab.ui.control.Image
        playerCard2       matlab.ui.control.Image
        playerCard3       matlab.ui.control.Image
        playerCard4       matlab.ui.control.Image
        playerCard5       matlab.ui.control.Image
        playerCard6       matlab.ui.control.Image
        playerCard7       matlab.ui.control.Image
        playerCard8       matlab.ui.control.Image
        playerCard9       matlab.ui.control.Image
        playerCard10      matlab.ui.control.Image
        playerCard11      matlab.ui.control.Image
        dealerCard1       matlab.ui.control.Image
        dealerCard2       matlab.ui.control.Image
        dealerCard3       matlab.ui.control.Image
        dealerCard4       matlab.ui.control.Image
        dealerCard5       matlab.ui.control.Image
        dealerCard6       matlab.ui.control.Image
        dealerCard7       matlab.ui.control.Image
        dealerCard8       matlab.ui.control.Image
        dealerCard9       matlab.ui.control.Image
        dealerCard10      matlab.ui.control.Image
        dealerCardHidden  matlab.ui.control.Image
        Label             matlab.ui.control.Label
        betText           matlab.ui.control.TextArea
        TOTALLabel        matlab.ui.control.Label
        moneyText         matlab.ui.control.TextArea
        EnternewbetamountEditFieldLabel  matlab.ui.control.Label
        changeBetField    matlab.ui.control.NumericEditField
        playerBlackjack   matlab.ui.control.Label
        win               matlab.ui.control.Label
        lose              matlab.ui.control.Label
        push              matlab.ui.control.Label
        valuesCheckBox    matlab.ui.control.CheckBox
        dealerValueText   matlab.ui.control.NumericEditField
        playerValueText   matlab.ui.control.NumericEditField
        gameOverMsg       matlab.ui.control.TextArea
        overBet           matlab.ui.control.Label
        statsCheckBox     matlab.ui.control.CheckBox
        statsGraph        matlab.ui.control.UIAxes
    end

    % Variables used in multiple functions
    properties (Access = private)
        Deck = 1:52; % deck matrix cards used not replaced
        indexPlayer = 3; % index of what card to show for player
        indexDealer  = 3; % index of what car to show for dealer
        playerVal % player value 
        dealerVal % dealer value
        bet = 0 % bet amount
        money = 100 % total money
        a % first card value for player
        b % second card value for player
        c % every card value for player from a hit
        x % first card value for dealer
        y % second card value for dealer
        z % every card value for dealer from a hit
        wins = 0; % number of wins
        losses = 0; % number of losses
        pushes = 0; % number of pushes
        blackjacks = 0; % number of blackjacks
    end
    
    methods (Access = private)
        
        % This function creates the deck and deals the cards  
        % Coded by Maria 11/23/2019
        function [cardStr,deck,cardVal] = deal(app,deck) 
            fid = fopen('cardFileNames.txt','r'); % Reading card txt file
            if fid == -1
                error('Cannot open the file!');
            end
            
            % Reshuffling deck after all cars have been delt
            if isempty(deck)
                deck = 1:52;
                
                % Playing shuffling audio 
                audioFile = 'shuffleSound.mp3';
                clear w Fs
                [w, Fs,] = audioread(audioFile);
                sound (w, Fs);
            end
            
            % Selecting a random number that corrsponds with the card in
            % the txt file 
            cardIndex = randi([1 length(deck)]); 
            
            % For loop so that same cards are not drawn twice
            for i = 1:deck(cardIndex)-1
                fgets(fid);
            end
            
            % Gathering card information from the txt file
            cardStr = fscanf(fid,'%s',1); % Card image file name 
            deck(cardIndex) = [];
            cardVal = fscanf(fid,'%d',1); % Card value
            fclose(fid);
        end
        
        % This function takes in the value of player and dealer hand and
        % calculates if it is a blackjack, bust, or deal again 
        % Coded by Camron 11/21/2019
        function [playerRes,dealerRes] = outcome(app,playerVal,dealerVal)
            narginchk(2, 3);
            if nargin == 2
                dealerVal = 0;
            end
            if playerVal == 21 %If player has a blackjack 
                playerRes = 1;
            elseif playerVal > 21 %If player has a bust
                playerRes = 2;
            elseif playerVal < 21 %If player can deal again
                playerRes = 3;
            else % Display error if something goes wrong
                error('something went wrong in the check function')
            end
            if dealerVal == 21 % If dealer has a blackjack 
                dealerRes = 1;
            elseif dealerVal > 21 %If dealer has a bust
                dealerRes = 2;
            elseif dealerVal < 21 %If dealer is lower than 21
                dealerRes = 3;
            else % Display error if something goes wrong
                error('something went wrong in the check function')
            end
        end
        
        % Function to reset the game for a new hand
        % Coded by Camron 11/23/2019
        function reset(app)
            
            % If players money is 0 or less display game over a quit
            % program
            if app.money <= 0 
                app.gameOverMsg.Visible = 'on';
                pause(2);
                closereq;
            %resetting visuals for new turn
            else
                app.lose.Visible = 'off';
                app.win.Visible = 'off';
                app.push.Visible = 'off';
                app.playerBlackjack.Visible = 'off';
                app.standButton.Visible = 'off';
                app.hitButton.Visible = 'off';
                pause(2);
                if app.bet <= app.money % bet never greater than money
                    app.dealButton.Visible = 'on';
                end
                app.betButton.Visible = 'on';
                app.playerCard1.Visible = 'off';
                app.playerCard2.Visible = 'off';
                app.playerCard3.Visible = 'off';
                app.playerCard4.Visible = 'off';
                app.playerCard5.Visible = 'off';
                app.playerCard6.Visible = 'off';
                app.playerCard7.Visible = 'off';
                app.playerCard8.Visible = 'off';
                app.playerCard9.Visible = 'off';
                app.playerCard10.Visible = 'off';
                app.playerCard11.Visible = 'off';
                app.dealerCard1.Visible = 'off';
                app.dealerCard2.Visible = 'off';
                app.dealerCard3.Visible = 'off';
                app.dealerCard4.Visible = 'off';
                app.dealerCard5.Visible = 'off';
                app.dealerCard6.Visible = 'off';
                app.dealerCard7.Visible = 'off';
                app.dealerCard8.Visible = 'off';
                app.dealerCard9.Visible = 'off';
                app.dealerCard10.Visible = 'off';
                app.dealerCardHidden.Visible = 'off';
                app.dealerValueText.Value = 0;
                app.playerValueText.Value = 0;
                app.indexPlayer = 3;
                app.indexDealer = 3;
                app.playerVal = 0;
                app.dealerVal = 0;
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: betButton
        % When the bet button is pushed by player
        % Coded by Maria 11/23/2019
        function changeBetPushed(app, event)
            app.betText.Visible = 'off';
            app.Label.Visible = 'off';
            
            % Allowing player to input new bet amount
            app.EnternewbetamountEditFieldLabel.Visible = 'on';
            app.changeBetField.Visible = 'on';
        end

        % Value changed function: changeBetField
        % When the value of the bet is changed by player
        % Coded by Maria 11/23/2019
        function betChanged(app, event)
            value = app.changeBetField.Value;
            
            % Turning on and off visuals so that game is more user friendly
            if value > app.money  % if attempting to overbet
                app.overBet.Visible = 'on';
                app.EnternewbetamountEditFieldLabel.Visible = 'off';
                app.changeBetField.Visible = 'off';
                app.betText.Visible = 'on';
                app.Label.Visible = 'on';
                pause(2);
                app.overBet.Visible = 'off';
                app.changeBetField.Value = app.bet;
            else % bet input is valid
                app.overBet.Visible = 'off';
                app.EnternewbetamountEditFieldLabel.Visible = 'off';
                app.changeBetField.Visible = 'off';
                app.betText.Visible = 'on';
                app.Label.Visible = 'on';
                app.betText.Value = num2str(value);
                
                % Showing an image of chips if the player has input a bet
                if value >= 1 
                    app.chipsImg.Visible = 'on';
                    app.dealButton.Visible = 'on';
                elseif value < 1
                    app.chipsImg.Visible = 'off';
                end
                app.bet = value;
            end
        end

        % Button pushed function: dealButton
        % When the deal button is pushed by player
        % Coded by Camron and Maria 11/26/2019
        function dealPushed(app, event) 
            
            % Playing cards being delt audio when deal button is pushed
            audioFile1 = 'deltCards.mp3';
            clear g Gs
            [g, Gs,] = audioread(audioFile1);
            sound (g, Gs);
            
            % Turning on and off visuals so that game is more user friendly
            app.betButton.Visible = 'off';
            app.hitButton.Visible = 'on';
            app.standButton.Visible = 'on';
            app.dealButton.Visible = 'off';
            app.playerCard1.Visible = 'on';
            app.playerCard2.Visible = 'on';
            app.dealerCard1.Visible = 'on';
            app.dealerCardHidden.Visible = 'on';
            deck = app.Deck;
            
            % Using deal function to return image sources
            [cardStr,deck,app.a] = deal(app,deck);
            app.playerCard1.ImageSource = cardStr;
            [cardStr,deck,app.b] = deal(app,deck);
            app.playerCard2.ImageSource = cardStr;
            app.playerVal = app.a + app.b;
            
            % Aces valued at 11 until buts then change to 1s
            while (app.playerVal > 21) && (app.a == 11 || app.b == 11)
                if app.a == 11
                    app.playerVal = app.playerVal - 10;
                    app.a = 1;
                elseif app.b == 11
                    app.playerVal = app.playerVal - 10;
                    app.b = 1;
                end
            end
            
            % If a blackjack for the player occurs
            app.playerValueText.Value = app.playerVal;
            [pres,dres] = outcome(app,app.playerVal);
            if pres == 1
                
                % Calculating players new money amount after winning hand
                % based off of the bet input
                app.money = app.money + 2*app.bet;
                
                % Displaying that player got blackjack
                app.moneyText.Value = num2str(app.money);
                app.playerBlackjack.Visible = 'on';
                pause(2);  % Short pause so player can see results 
                
                % adding up number of blackjacks and wins for stats
                app.blackjacks = app.blackjacks + 1;
                app.wins = app.wins + 1;
                reset(app);% Start a new turn with reset function
            end
            % Using deal function to return image sources
            [cardStr,deck,app.x] = deal(app,deck);
            app.dealerCard1.ImageSource = cardStr;
            [cardStr,deck,app.y] = deal(app,deck);
            app.dealerCard2.ImageSource = cardStr;
            app.Deck = deck;
            app.dealerVal = app.x + app.y;
            
            % Aces valued at 11 until buts then change to 1s
            while (app.dealerVal > 21) && (app.x == 11 || app.y == 11)
                if app.x == 11
                    app.dealerVal = app.dealerVal - 10;
                    app.x = 1;
                elseif app.y == 11
                    app.dealerVal = app.dealerVal - 10;
                    app.y = 1;
                end
            end
        end

        % Button pushed function: hitButton
        % When the hit button is pushed by player
        % Coded by Maria 11/26/2019
        function hitPushed(app, event) 
            count = app.indexPlayer;
            deck = app.Deck;
            
            % Displaying card images in correct positions based off number 
            % of delt cards,  
            if count == 3 % Third Player Card
                app.playerCard3.Visible = 'on';
                [cardStr,deck,app.c] = deal(app,deck);
                app.playerCard3.ImageSource = cardStr;
                count = count + 1;
            elseif count == 4 % Fourth Player Card
                app.playerCard4.Visible = 'on';
                [cardStr,deck,app.c] = deal(app,deck);
                app.playerCard4.ImageSource = cardStr;
                count = count + 1;
            elseif count == 5 % Fifth Player Card
                app.playerCard5.Visible = 'on';
                [cardStr,deck,app.c] = deal(app,deck);
                app.playerCard5.ImageSource = cardStr;
                count = count + 1;
            elseif count == 6 % Sixth Player Card
                app.playerCard6.Visible = 'on';
                [cardStr,deck,app.c] = deal(app,deck);
                app.playerCard6.ImageSource = cardStr;
                count = count + 1;
            elseif count == 7 % Seventh Player Card
                app.playerCard7.Visible = 'on';
                [cardStr,deck,app.c] = deal(app,deck);
                app.playerCard7.ImageSource = cardStr;
                count = count + 1;
            elseif count == 8 % Eighth Player Card
                app.playerCard8.Visible = 'on';
                [cardStr,deck,app.c] = deal(app,deck);
                app.playerCard8.ImageSource = cardStr;
                count = count + 1;
            elseif count == 9 % Ninth Player Card
                app.playerCard9.Visible = 'on';
                [cardStr,deck,app.c] = deal(app,deck);
                app.playerCard9.ImageSource = cardStr;
                count = count + 1;
            elseif count == 10 % Tenth Palyer Card
                app.playerCard10.Visible = 'on';
                [cardStr,deck,app.c] = deal(app,deck);
                app.playerCard10.ImageSource = cardStr;
                count = count + 1;
            elseif count == 11 % Eleventh Player Card
                app.playerCard11.Visible = 'on';
                [cardStr,deck,app.c] = deal(app,deck);
                app.playerCard11.ImageSource = cardStr;
                count = count + 1;
            end
            app.indexPlayer = count;
            app.Deck = deck;
            % Calculate value
            app.playerVal = app.playerVal + app.c;
            
            % ACES 1 OR 11
            while (app.playerVal > 21)...
                    && (app.a == 11 || app.b == 11 || app.c == 11)
                if app.a == 11
                    app.playerVal = app.playerVal - 10;
                    app.a = 1;
                elseif app.b == 11
                    app.playerVal = app.playerVal - 10;
                    app.b = 1;
                elseif app.c == 11
                    app.playerVal = app.playerVal - 10;
                    app.c = 1;
                end
            end
            
            % If the results of the game is a bust for the player
            app.playerValueText.Value = app.playerVal;
            [pres,dres] = outcome(app,app.playerVal);
            if pres == 2
                
                % Calculating players new money amount after losing hand
                % based off of the bet input
                app.money = app.money - app.bet;
                
                % Displaying that player lost hand
                app.moneyText.Value = num2str(app.money);
                app.lose.Visible = 'on'; 
               
                % adding up number of losses for stats
                app.losses = app.losses + 1; 
                pause(2); % Short pause so player can see results
                reset(app); % Start a new turn
            end
        end

        % Button pushed function: standButton
        % Coded by Camron 11/27/2019
        function standPushed(app, event)
            app.standButton.Visible = 'off';
            app.hitButton.Visible = 'off';
            app.dealerCardHidden.Visible = 'off';
            app.dealerCard2.Visible = 'on';
            app.dealerValueText.Value = app.dealerVal;
            while app.dealerVal < 17 % Dealer hiting until 17 
                count = app.indexDealer;
                deck = app.Deck;
                if count == 3
                    app.dealerCard3.Visible = 'on';
                    [cardStr,deck,app.z] = deal(app,deck);
                    app.dealerCard3.ImageSource = cardStr;
                    count = count + 1;
                elseif count == 4
                    app.dealerCard4.Visible = 'on';
                    [cardStr,deck,app.z] = deal(app,deck);
                    app.dealerCard4.ImageSource = cardStr;
                    count = count + 1;
                elseif count == 5
                    app.dealerCard5.Visible = 'on';
                    [cardStr,deck,app.z] = deal(app,deck);
                    app.dealerCard5.ImageSource = cardStr;
                    count = count + 1;
                elseif count == 6
                    app.dealerCard6.Visible = 'on';
                    [cardStr,deck,app.z] = deal(app,deck);
                    app.dealerCard6.ImageSource = cardStr;
                    count = count + 1;
                elseif count == 7
                    app.dealerCard7.Visible = 'on';
                    [cardStr,deck,app.z] = deal(app,deck);
                    app.dealerCard7.ImageSource = cardStr;
                    count = count + 1;
                elseif count == 8
                    app.dealerCard8.Visible = 'on';
                    [cardStr,deck,app.z] = deal(app,deck);
                    app.dealerCard8.ImageSource = cardStr;
                    count = count + 1;
                elseif count == 9
                    app.dealerCard9.Visible = 'on';
                    [cardStr,deck,app.z] = deal(app,deck);
                    app.dealerCard9.ImageSource = cardStr;
                    count = count + 1;
                elseif count == 10
                    app.dealerCard10.Visible = 'on';
                    [cardStr,deck,app.z] = deal(app,deck);
                    app.dealerCard10.ImageSource = cardStr;
                    count = count + 1;
                end
                app.indexDealer = count;
                app.Deck = deck;
                % Calculate
                app.dealerVal = app.dealerVal + app.z;
                
                % ACES 1 OR 11
                while (app.dealerVal > 21)...
                        && (app.x == 11 || app.y == 11 || app.z == 11)
                    if app.x == 11
                        app.dealerVal = app.dealerVal - 10;
                        app.x = 1;
                    elseif app.y == 11
                        app.dealerVal = app.dealerVal - 10;
                        app.y = 1;
                    elseif app.z == 11
                        app.dealerVal = app.dealerVal - 10;
                        app.z = 1;
                    end
                end
                
                app.dealerValueText.Value = app.dealerVal;
                pause(0.5);
            end
            
            % Function that determines the outcome of the hand after stand 
            % or hit 
            [pres,dres] = outcome(app,app.playerVal,app.dealerVal);
            if dres == 1 && app.indexDealer == 3 % blackjack
                app.money = app.money - app.bet; 
                app.lose.Visible = 'on';
                pause(2);% Short pause so player can see results
                app.losses = app.losses + 1;
                reset(app);% Start a new turn with reset function
            elseif dres == 2 % bust
                app.money = app.money + app.bet;
                app.win.Visible = 'on';
                pause(2);% Short pause so player can see results
                app.wins = app.wins + 1;
                reset(app);% Start a new turn
            else
                if app.dealerVal == app.playerVal % push
                    app.push.Visible = 'on';
                    pause(2);% Short pause so player can see results
                    app.pushes = app.pushes + 1;
                    reset(app);% Start a new turn with reset function
                elseif app.dealerVal > app.playerVal % dealer wins
                    app.money = app.money - app.bet;
                    app.lose.Visible = 'on';
                    pause(2);% Short pause so player can see results
                    app.losses = app.losses + 1;
                    reset(app);% Start a new turn with reset function
                elseif app.playerVal > app.dealerVal % player wins
                    app.money = app.money + app.bet;
                    app.win.Visible = 'on';
                    pause(2);% Short pause so player can see results
                    app.wins = app.wins + 1;
                    reset(app);% Start a new turn with reset function
                end
            end
            app.moneyText.Value = num2str(app.money);
        end

        % Value changed function: valuesCheckBox
        % Coded by Maria 11/30/2019
        function showValues(app, event)
            value = app.valuesCheckBox.Value;
            if value == 1 % Checked
                app.dealerValueText.Visible = 'on';
                app.playerValueText.Visible = 'on';
            else % unchecked
                app.dealerValueText.Visible = 'off';
                app.playerValueText.Visible = 'off';
            end
        end

        % Value changed function: statsCheckBox
        % Displaying bar graph showing the amount of Wins, Losses, 
        % Pushes, and Blackjacks throughout the game play
        % Coded by Camron 11/30/2019
        function showStats(app, event)
            value = app.statsCheckBox.Value;
            if value == 1 % If player checks the stats checkbox
                app.statsGraph.Position = [192,145,300,217];
                data = [app.wins app.losses app.pushes app.blackjacks];
                categorie =...
                    categorical({'Wins','Losses','Pushes','Blackjacks'});
                graph =...
                    bar(app.statsGraph,categorie,data,'faceColor','flat');
                graph.CData = [0 0 1; 0 1 0; 1 0 0; 0.5 0 0.5];
            else % If player unchecks the stats checkbox
                app.statsGraph.Position = [192,145,0,0];
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create all of the UI figures and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 673 504];
            app.UIFigure.Name = 'UI Figure';

            % Create backgroundImg
            app.backgroundImg = uiimage(app.UIFigure);
            app.backgroundImg.Position = [1 1 673 504];
            app.backgroundImg.ImageSource = 'blackjackTable.png';

            % Create hitButton
            app.hitButton = uibutton(app.UIFigure, 'push');
            app.hitButton.ButtonPushedFcn =...
                createCallbackFcn(app, @hitPushed, true);
            app.hitButton.BackgroundColor = [0.902 0.902 0.902];
            app.hitButton.FontName = 'Times New Roman';
            app.hitButton.FontSize = 24;
            app.hitButton.FontWeight = 'bold';
            app.hitButton.FontColor = [0.502 0.502 0.502];
            app.hitButton.Visible = 'off';
            app.hitButton.Position = [549 10 95 91];
            app.hitButton.Text = {'HIT'; ''};

            % Create standButton
            app.standButton = uibutton(app.UIFigure, 'push');
            app.standButton.ButtonPushedFcn =...
                createCallbackFcn(app, @standPushed, true);
            app.standButton.BackgroundColor = [0.902 0.902 0.902];
            app.standButton.FontName = 'Times New Roman';
            app.standButton.FontSize = 24;
            app.standButton.FontWeight = 'bold';
            app.standButton.FontColor = [0.502 0.502 0.502];
            app.standButton.Visible = 'off';
            app.standButton.Position = [34 10 95 91];
            app.standButton.Text = 'STAND';

            % Create dealButton
            app.dealButton = uibutton(app.UIFigure, 'push');
            app.dealButton.ButtonPushedFcn =...
                createCallbackFcn(app, @dealPushed, true);
            app.dealButton.BackgroundColor = [0 0.4471 0.7412];
            app.dealButton.FontName = 'Times New Roman';
            app.dealButton.FontSize = 24;
            app.dealButton.FontWeight = 'bold';
            app.dealButton.FontColor = [0.9412 0.9412 0.9412];
            app.dealButton.Visible = 'off';
            app.dealButton.Position = [351 63 95 38];
            app.dealButton.Text = 'DEAL';

            % Create betButton
            app.betButton = uibutton(app.UIFigure, 'push');
            app.betButton.ButtonPushedFcn =...
                createCallbackFcn(app, @changeBetPushed, true);
            app.betButton.BackgroundColor = [0.851 0.3255 0.098];
            app.betButton.FontName = 'Times New Roman';
            app.betButton.FontSize = 14;
            app.betButton.FontWeight = 'bold';
            app.betButton.FontColor = [0.9412 0.9412 0.9412];
            app.betButton.Position = [230 63 108 38];
            app.betButton.Text = 'CHANGE BET';

            % Create chipsImg
            app.chipsImg = uiimage(app.UIFigure);
            app.chipsImg.Visible = 'off';
            app.chipsImg.Position = [108 244 58 48];
            app.chipsImg.ImageSource = 'pokerChips.png';

            % Create playerCard1
            app.playerCard1 = uiimage(app.UIFigure);
            app.playerCard1.Visible = 'off';
            app.playerCard1.Position = [230 198 71 76];
            app.playerCard1.ImageSource = '2C.png';

            % Create playerCard2
            app.playerCard2 = uiimage(app.UIFigure);
            app.playerCard2.Visible = 'off';
            app.playerCard2.Position = [281 198 71 76];
            app.playerCard2.ImageSource = '2C.png';

            % Create playerCard3
            app.playerCard3 = uiimage(app.UIFigure);
            app.playerCard3.Visible = 'off';
            app.playerCard3.Position = [332 198 71 76];
            app.playerCard3.ImageSource = '2C.png';

            % Create playerCard4
            app.playerCard4 = uiimage(app.UIFigure);
            app.playerCard4.Visible = 'off';
            app.playerCard4.Position = [383 198 71 76];
            app.playerCard4.ImageSource = '2C.png';

            % Create playerCard5
            app.playerCard5 = uiimage(app.UIFigure);
            app.playerCard5.Visible = 'off';
            app.playerCard5.Position = [434 198 71 76];
            app.playerCard5.ImageSource = '2C.png';

            % Create playerCard6
            app.playerCard6 = uiimage(app.UIFigure);
            app.playerCard6.Visible = 'off';
            app.playerCard6.Position = [485 198 71 76];
            app.playerCard6.ImageSource = '2C.png';

            % Create playerCard7
            app.playerCard7 = uiimage(app.UIFigure);
            app.playerCard7.Visible = 'off';
            app.playerCard7.Position = [536 198 71 76];
            app.playerCard7.ImageSource = '2C.png';

            % Create playerCard8
            app.playerCard8 = uiimage(app.UIFigure);
            app.playerCard8.Visible = 'off';
            app.playerCard8.Position = [588 198 71 76];
            app.playerCard8.ImageSource = '2C.png';

            % Create playerCard9
            app.playerCard9 = uiimage(app.UIFigure);
            app.playerCard9.Visible = 'off';
            app.playerCard9.Position = [486 120 71 76];
            app.playerCard9.ImageSource = '2C.png';

            % Create playerCard10
            app.playerCard10 = uiimage(app.UIFigure);
            app.playerCard10.Visible = 'off';
            app.playerCard10.Position = [537 120 71 76];
            app.playerCard10.ImageSource = '2C.png';

            % Create playerCard11
            app.playerCard11 = uiimage(app.UIFigure);
            app.playerCard11.Visible = 'off';
            app.playerCard11.Position = [589 120 71 76];
            app.playerCard11.ImageSource = '2C.png';

            % Create dealerCard1
            app.dealerCard1 = uiimage(app.UIFigure);
            app.dealerCard1.Visible = 'off';
            app.dealerCard1.Position = [231 396 71 76];
            app.dealerCard1.ImageSource = '2C.png';

            % Create dealerCard2
            app.dealerCard2 = uiimage(app.UIFigure);
            app.dealerCard2.Visible = 'off';
            app.dealerCard2.Position = [282 396 71 76];
            app.dealerCard2.ImageSource = '2C.png';

            % Create dealerCard3
            app.dealerCard3 = uiimage(app.UIFigure);
            app.dealerCard3.Visible = 'off';
            app.dealerCard3.Position = [333 396 71 76];
            app.dealerCard3.ImageSource = '2C.png';

            % Create dealerCard4
            app.dealerCard4 = uiimage(app.UIFigure);
            app.dealerCard4.Visible = 'off';
            app.dealerCard4.Position = [384 396 71 76];
            app.dealerCard4.ImageSource = '2C.png';

            % Create dealerCard5
            app.dealerCard5 = uiimage(app.UIFigure);
            app.dealerCard5.Visible = 'off';
            app.dealerCard5.Position = [435 396 71 76];
            app.dealerCard5.ImageSource = '2C.png';

            % Create dealerCard6
            app.dealerCard6 = uiimage(app.UIFigure);
            app.dealerCard6.Visible = 'off';
            app.dealerCard6.Position = [487 396 71 76];
            app.dealerCard6.ImageSource = '2C.png';

            % Create dealerCard7
            app.dealerCard7 = uiimage(app.UIFigure);
            app.dealerCard7.Visible = 'off';
            app.dealerCard7.Position = [538 396 71 76];
            app.dealerCard7.ImageSource = '2C.png';

            % Create dealerCard8
            app.dealerCard8 = uiimage(app.UIFigure);
            app.dealerCard8.Visible = 'off';
            app.dealerCard8.Position = [590 396 71 76];
            app.dealerCard8.ImageSource = '2C.png';

            % Create dealerCard9
            app.dealerCard9 = uiimage(app.UIFigure);
            app.dealerCard9.Visible = 'off';
            app.dealerCard9.Position = [539 318 71 76];
            app.dealerCard9.ImageSource = '2C.png';

            % Create dealerCard10
            app.dealerCard10 = uiimage(app.UIFigure);
            app.dealerCard10.Visible = 'off';
            app.dealerCard10.Position = [591 318 71 76];
            app.dealerCard10.ImageSource = '2C.png';

            % Create dealerCardHidden
            app.dealerCardHidden = uiimage(app.UIFigure);
            app.dealerCardHidden.Visible = 'off';
            app.dealerCardHidden.Position = [283 396 69 76];
            app.dealerCardHidden.ImageSource = 'red_back.png';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.VerticalAlignment = 'top';
            app.Label.FontName = 'Times New Roman';
            app.Label.FontSize = 16;
            app.Label.FontWeight = 'bold';
            app.Label.FontColor = [0.9412 0.9412 0.9412];
            app.Label.Position = [80 295 29 22];
            app.Label.Text = '$';

            % Create betText
            app.betText = uitextarea(app.UIFigure);
            app.betText.Editable = 'off';
            app.betText.HorizontalAlignment = 'center';
            app.betText.FontName = 'Times New Roman';
            app.betText.FontSize = 16;
            app.betText.FontWeight = 'bold';
            app.betText.Position = [111 294 55 25];
            app.betText.Value = {'0'};

            % Create TOTALLabel
            app.TOTALLabel = uilabel(app.UIFigure);
            app.TOTALLabel.HorizontalAlignment = 'right';
            app.TOTALLabel.VerticalAlignment = 'top';
            app.TOTALLabel.FontName = 'Times New Roman';
            app.TOTALLabel.FontSize = 16;
            app.TOTALLabel.FontWeight = 'bold';
            app.TOTALLabel.FontColor = [0.9412 0.9412 0.9412];
            app.TOTALLabel.Position = [230 113 72 22];
            app.TOTALLabel.Text = 'TOTAL $';

            % Create moneyText
            app.moneyText = uitextarea(app.UIFigure);
            app.moneyText.Editable = 'off';
            app.moneyText.HorizontalAlignment = 'center';
            app.moneyText.FontName = 'Times New Roman';
            app.moneyText.FontSize = 16;
            app.moneyText.FontWeight = 'bold';
            app.moneyText.Position = [315 112 131 25];
            app.moneyText.Value = {'100'};

            % Create EnternewbetamountEditFieldLabel
            app.EnternewbetamountEditFieldLabel = uilabel(app.UIFigure);
            app.EnternewbetamountEditFieldLabel.HorizontalAlignment =...
                'right';
            app.EnternewbetamountEditFieldLabel.FontName =...
                'Times New Roman';
            app.EnternewbetamountEditFieldLabel.FontSize = 16;
            app.EnternewbetamountEditFieldLabel.FontWeight = 'bold';
            app.EnternewbetamountEditFieldLabel.FontColor =...
                [0.9412 0.9412 0.9412];
            app.EnternewbetamountEditFieldLabel.Visible = 'off';
            app.EnternewbetamountEditFieldLabel.Position = [56 316 163 22];
            app.EnternewbetamountEditFieldLabel.Text =...
                'Enter new bet amount:';

            % Create changeBetField
            app.changeBetField = uieditfield(app.UIFigure, 'numeric');
            app.changeBetField.RoundFractionalValues = 'on';
            app.changeBetField.ValueChangedFcn =...
                createCallbackFcn(app, @betChanged, true);
            app.changeBetField.HorizontalAlignment = 'center';
            app.changeBetField.FontName = 'Times New Roman';
            app.changeBetField.FontSize = 16;
            app.changeBetField.FontWeight = 'bold';
            app.changeBetField.Visible = 'off';
            app.changeBetField.Position = [110 295 57 22];

            % Create playerBlackjack
            app.playerBlackjack = uilabel(app.UIFigure);
            app.playerBlackjack.FontName = 'Times New Roman';
            app.playerBlackjack.FontSize = 45;
            app.playerBlackjack.FontWeight = 'bold';
            app.playerBlackjack.FontColor = [0.6353 0.0784 0.1843];
            app.playerBlackjack.Visible = 'off';
            app.playerBlackjack.Position = [185 328 307 56];
            app.playerBlackjack.Text = 'BLACKJACK!';

            % Create win
            app.win = uilabel(app.UIFigure);
            app.win.FontName = 'Times New Roman';
            app.win.FontSize = 45;
            app.win.FontWeight = 'bold';
            app.win.FontColor = [0.6353 0.0784 0.1843];
            app.win.Visible = 'off';
            app.win.Position = [224 328 229 56];
            app.win.Text = 'YOU WIN!';

            % Create lose
            app.lose = uilabel(app.UIFigure);
            app.lose.FontName = 'Times New Roman';
            app.lose.FontSize = 45;
            app.lose.FontWeight = 'bold';
            app.lose.FontColor = [0.6353 0.0784 0.1843];
            app.lose.Visible = 'off';
            app.lose.Position = [219 328 239 56];
            app.lose.Text = 'YOU LOSE';

            % Create push
            app.push = uilabel(app.UIFigure);
            app.push.FontName = 'Times New Roman';
            app.push.FontSize = 45;
            app.push.FontWeight = 'bold';
            app.push.FontColor = [0.6353 0.0784 0.1843];
            app.push.Visible = 'off';
            app.push.Position = [276 328 125 56];
            app.push.Text = 'PUSH';

            % Create valuesCheckBox
            app.valuesCheckBox = uicheckbox(app.UIFigure);
            app.valuesCheckBox.ValueChangedFcn =...
                createCallbackFcn(app, @showValues, true);
            app.valuesCheckBox.Text = {'Show Values'; ''};
            app.valuesCheckBox.FontName = 'Times New Roman';
            app.valuesCheckBox.FontSize = 16;
            app.valuesCheckBox.FontWeight = 'bold';
            app.valuesCheckBox.FontColor = [0.9412 0.9412 0.9412];
            app.valuesCheckBox.Position = [543 483 108 22];

            % Create dealerValueText
            app.dealerValueText = uieditfield(app.UIFigure, 'numeric');
            app.dealerValueText.Editable = 'off';
            app.dealerValueText.HorizontalAlignment = 'center';
            app.dealerValueText.FontName = 'Times New Roman';
            app.dealerValueText.FontSize = 16;
            app.dealerValueText.FontWeight = 'bold';
            app.dealerValueText.Visible = 'off';
            app.dealerValueText.Position = [174 423 32 22];

            % Create playerValueText
            app.playerValueText = uieditfield(app.UIFigure, 'numeric');
            app.playerValueText.Editable = 'off';
            app.playerValueText.HorizontalAlignment = 'center';
            app.playerValueText.FontName = 'Times New Roman';
            app.playerValueText.FontSize = 16;
            app.playerValueText.FontWeight = 'bold';
            app.playerValueText.Visible = 'off';
            app.playerValueText.Position = [174 225 32 22];

            % Create gameOverMsg
            app.gameOverMsg = uitextarea(app.UIFigure);
            app.gameOverMsg.HorizontalAlignment = 'center';
            app.gameOverMsg.FontName = 'Times New Roman';
            app.gameOverMsg.FontSize = 40;
            app.gameOverMsg.FontWeight = 'bold';
            app.gameOverMsg.FontColor = [0.9412 0.9412 0.9412];
            app.gameOverMsg.BackgroundColor = [0 0 0];
            app.gameOverMsg.Visible = 'off';
            app.gameOverMsg.Position = [139 104 398 299];
            app.gameOverMsg.Value =...
                {''; ''; 'You ran out of money.'; 'GAME OVER'};

            % Create overBet
            app.overBet = uilabel(app.UIFigure);
            app.overBet.HorizontalAlignment = 'center';
            app.overBet.FontName = 'Times New Roman';
            app.overBet.FontSize = 16;
            app.overBet.FontWeight = 'bold';
            app.overBet.FontColor = [1 0 0];
            app.overBet.Visible = 'off';
            app.overBet.Position = [165 287 143 38];
            app.overBet.Text = {'You don''t have that '; 'much money.'};

            % Create statsCheckBox
            app.statsCheckBox = uicheckbox(app.UIFigure);
            app.statsCheckBox.ValueChangedFcn =...
                createCallbackFcn(app, @showStats, true);
            app.statsCheckBox.Text = 'Stats';
            app.statsCheckBox.FontName = 'Times New Roman';
            app.statsCheckBox.FontSize = 16;
            app.statsCheckBox.FontWeight = 'bold';
            app.statsCheckBox.FontColor = [0.9412 0.9412 0.9412];
            app.statsCheckBox.Position = [28 483 56 22];

            % Create statsGraph
            app.statsGraph = uiaxes(app.UIFigure);
            title(app.statsGraph, 'Statistics')
            xlabel(app.statsGraph, '')
            ylabel(app.statsGraph, '')
            app.statsGraph.FontName = 'Times New Roman';
            app.statsGraph.FontWeight = 'bold';
            app.statsGraph.Position = [192 145 0 0];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = blackjack_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end