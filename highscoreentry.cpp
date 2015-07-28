#include <highscoreentry.h>

HighScoreEntry::HighScoreEntry()
{}


HighScoreEntry::HighScoreEntry(const quint64 timeInMs, const QString &playerName, const GameMode mode):
    m_timeInMs(timeInMs), m_playerName(playerName), m_gameMode(mode)
{

}

HighScoreEntry::operator QVariant() const
{
    return QVariant::fromValue(*this);
}

bool HighScoreEntry::operator<(const HighScoreEntry& other) const {
        return this->m_timeInMs < other.m_timeInMs;
    }

bool HighScoreEntry::operator==(const HighScoreEntry& other) const {
    return (this->m_gameMode == other.m_gameMode)&&(this->m_timeInMs == other.m_timeInMs);
}

void HighScoreEntry::setPlayerName(const QString &name)
{
    m_playerName = name;
}

void HighScoreEntry::setTimeInMs(const quint64 timeInMs)
{
    m_timeInMs = timeInMs;
}

void HighScoreEntry::setGameMode(const GameMode mode)
{
    m_gameMode = mode;
}

QString HighScoreEntry::modeToString() const
{
    QString modeStr;

    switch(m_gameMode){
        case B2x2:
            modeStr = "2x2";
        break;
        case B3x3:
            modeStr = "3x3";
        break;
        case B4x4:
            modeStr = "4x4";
        break;
        case B5x5:
            modeStr = "5x5";
        break;
        case B6x6:
            modeStr = "6x6";
        break;
    }

    return modeStr;
}

QString HighScoreEntry::timeToString() const
{
    QString retString;
    ushort sec  = 0;
    ushort min  = 0;
    ushort hour = 0;

    quint64 tmpTime = m_timeInMs / 1000;

    sec = (tmpTime % 60);

    tmpTime = tmpTime / 60;
    min = (tmpTime % 60);

    tmpTime = tmpTime / 60;
    hour = (tmpTime % 60);

    retString = QString("%1:%2:%3").arg(hour,2,10,QChar('0')).arg(min,2,10,QChar('0')).arg(sec,2,10,QChar('0'));
    return retString;
}

QString HighScoreEntry::getPlayerName() const
{
    return m_playerName;
}

quint64 HighScoreEntry::getTimeInMs() const
{
    return m_timeInMs;
}

quint8 HighScoreEntry::getGameMode() const
{
    return m_gameMode;
}

QString HighScoreEntry::modeToString(GameMode gameMode)
{
    QString modeStr;

    switch(gameMode){
        case B2x2:
            modeStr = "2x2";
        break;
        case B3x3:
            modeStr = "3x3";
        break;
        case B4x4:
            modeStr = "4x4";
        break;
        case B5x5:
            modeStr = "5x5";
        break;
        case B6x6:
            modeStr = "6x6";
        break;
    }

    return modeStr;
}

QString HighScoreEntry::timeToString(const quint64 timeInMs)
{
    quint8 sec  = 0;
    quint8 min  = 0;
    quint8 hour = 0;

    quint64 tmpTime = timeInMs / 1000;

    sec = (tmpTime % 60);

    tmpTime = tmpTime / 60;
    min = (tmpTime % 60);

    tmpTime = tmpTime / 60;
    hour = (tmpTime % 60);

    return QString("%1:%2:%3").arg(hour,2,10,QChar('0')).arg(min,2,10,QChar('0')).arg(sec,2,10,QChar('0'));
}



