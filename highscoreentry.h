#ifndef HIGHSCOREENTRY_H
#define HIGHSCOREENTRY_H

#include <QString>
#include <QTime>
#include <QVariant>

enum GameMode {
    B2x2 = 2,
    B3x3,
    B4x4,
    B5x5,
    B6x6
};

class HighScoreEntry
{
public:
    HighScoreEntry();
    HighScoreEntry(const quint64 timeInMs, const QString &playerName, const GameMode mode);

    operator QVariant() const;

    bool operator<(const HighScoreEntry& other) const;
    bool operator==(const HighScoreEntry& other) const;

    void setPlayerName(const QString& name);
    void setTimeInMs(const quint64 timeInMs);
    void setGameMode(const GameMode mode);

    QString getPlayerName() const;
    quint64 getTimeInMs() const;
    quint8  getGameMode() const;

    QString modeToString() const;
    QString timeToString() const;

    static QString modeToString(GameMode gameMode);
    static QString timeToString(const quint64 timeInMs);

private:
    quint64  m_timeInMs;
    QString  m_playerName;
    GameMode m_gameMode;
};
Q_DECLARE_METATYPE(HighScoreEntry)

inline QDataStream& operator<<(QDataStream& out, const HighScoreEntry& highScoreEntry)
{
    out << highScoreEntry.getTimeInMs();
    out << highScoreEntry.getPlayerName();
    out << highScoreEntry.getGameMode();

    return out;
}

inline QDataStream& operator>>(QDataStream& in, HighScoreEntry& highScoreEntry)
{
    quint64 timeInMs = 0;
    QString name;
    quint8  mode = 0;

    in >> timeInMs;
    in >> name;
    in >> mode;

    highScoreEntry.setTimeInMs(timeInMs);
    highScoreEntry.setPlayerName(name);
    highScoreEntry.setGameMode((GameMode)mode);

    return in;
}

#endif // HIGHSCOREENTRY_H
