import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatefulWidget {
  const TicTacToeApp({super.key});

  @override
  _TicTacToeAppState createState() => _TicTacToeAppState();
}

class _TicTacToeAppState extends State<TicTacToeApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: TicTacToeGame(
          toggleTheme: _toggleTheme, initialThemeMode: _themeMode),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  final Function(bool) toggleTheme;
  final ThemeMode initialThemeMode;

  const TicTacToeGame(
      {super.key, required this.toggleTheme, required this.initialThemeMode});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<List<String>> _board = List.generate(3, (_) => List.filled(3, ''));
  bool _xTurn = true;
  String _winner = '';
  int _xScore = 0;
  int _oScore = 0;

  void _makeMove(int row, int col) {
    if (_board[row][col] == '' && _winner == '') {
      setState(() {
        _board[row][col] = _xTurn ? 'X' : 'O';
        _xTurn = !_xTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    // Check rows, columns, and diagonals
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _board[i][1] &&
          _board[i][1] == _board[i][2] &&
          _board[i][0] != '') {
        _winner = _board[i][0];
        _updateScore();
        return;
      }
      if (_board[0][i] == _board[1][i] &&
          _board[1][i] == _board[2][i] &&
          _board[0][i] != '') {
        _winner = _board[0][i];
        _updateScore();
        return;
      }
    }
    if (_board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2] &&
        _board[0][0] != '') {
      _winner = _board[0][0];
      _updateScore();
      return;
    }
    if (_board[0][2] == _board[1][1] &&
        _board[1][1] == _board[2][0] &&
        _board[0][2] != '') {
      _winner = _board[0][2];
      _updateScore();
      return;
    }
  }

  void _updateScore() {
    if (_winner == 'X') {
      _xScore++;
    } else if (_winner == 'O') {
      _oScore++;
    }
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.filled(3, ''));
      _xTurn = true;
      _winner = '';
    });
  }

  void _resetScores() {
    setState(() {
      _xScore = 0;
      _oScore = 0;
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (bool value) {
                    widget.toggleTheme(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double boardSize = constraints.maxWidth > constraints.maxHeight
                ? constraints.maxHeight * 0.5
                : constraints.maxWidth * 0.8;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              _winner == ''
                                  ? 'Current Turn: ${_xTurn ? 'X' : 'O'}'
                                  : 'Winner: $_winner',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Score: X: $_xScore - O: $_oScore',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: boardSize,
                      height: boardSize,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          int row = index ~/ 3;
                          int col = index % 3;
                          return GestureDetector(
                            onTap: () => _makeMove(row, col),
                            child: Card(
                              elevation: 2,
                              child: Center(
                                child: Text(
                                  _board[row][col],
                                  style: TextStyle(fontSize: boardSize / 6),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        if (constraints.maxWidth > 400) {
                          // For larger screens, keep buttons side by side
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _resetGame,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Reset Game'),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                onPressed: _resetScores,
                                icon: const Icon(Icons.scoreboard),
                                label: const Text('Reset Scores'),
                              ),
                            ],
                          );
                        } else {
                          // For smaller screens, stack buttons vertically
                          return Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _resetGame,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Reset Game'),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: _resetScores,
                                icon: const Icon(Icons.scoreboard),
                                label: const Text('Reset Scores'),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
