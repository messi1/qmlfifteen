#include <QVariantList>
#include "highscorelistmodel.h"

HighScoreListModel::HighScoreListModel(QObject *parent):
QAbstractListModel(parent)
{
    qRegisterMetaType<HighScoreEntry>("HighScoreEntry");
    qRegisterMetaTypeStreamOperators<HighScoreEntry>("HighScoreEntry");

    QString name("BlaBla");
    HighScoreEntry e1(33000, name, B3x3);
    m_highScoreList.append(e1);
    HighScoreEntry e2(53000, name, B4x4);
    m_highScoreList.append(e2);
}

HighScoreListModel::~HighScoreListModel()
{

}

QVariant HighScoreListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch(role) {
        case ModeRole:
            return m_highScoreList.at(index.row()).modeToString();
        break;

        case TimeRole:
            return m_highScoreList.at(index.row()).timeToString();
        break;

        case NameRole:
            return m_highScoreList.at(index.row()).getPlayerName();
        break;

        default:
            return QVariant();
        break;
    }
}

bool HighScoreListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{

    if (index.isValid() ) {
        m_highScoreList.append(HighScoreEntry());
        emit dataChanged(index, index);
        return true;
    }

    return false;
}

QHash<int, QByteArray> HighScoreListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[ModeRole] = "mode";
    roles[TimeRole] = "time";
    roles[NameRole] = "name";
    return roles;
}

int HighScoreListModel::rowCount(const QModelIndex &) const
{
   return m_highScoreList.size();
}

void HighScoreListModel::loadHighScoreList()
{
    QVariantList reading = m_settings.value("highScoreList").toList();

    foreach(QVariant v, reading){
        m_highScoreList << v.value<HighScoreEntry>();
    }

    qSort(m_highScoreList);
}

void HighScoreListModel::saveHighScoreList()
{
    QVariantList highScoreListVariant;
    foreach(HighScoreEntry v, m_highScoreList) {
      highScoreListVariant << v;
    }
    m_settings.setValue("highScoreList", highScoreListVariant);
}

bool HighScoreListModel::checkIfEntryWillBeSaved(const quint64 &timeInMs, const int &mode)
{
    bool canBeInserted = false;

    int i = 0;
    HighScoreList tmpList;
    HighScoreEntry newEntry(timeInMs, "Unknow", (GameMode)mode);

    foreach(HighScoreEntry v, m_highScoreList) {
        if(v.getGameMode() == mode)
            tmpList << v;
    }

    if(tmpList.size() < 10) {
        m_highScoreList.append(newEntry);
        canBeInserted = true;
    }
    else {
        for(i=0; i<tmpList.size(); ++i) {
            if(newEntry.getTimeInMs() < tmpList[i].getTimeInMs())
            {
                tmpList.insert(i, newEntry);
                break;
            }
        }

        if(i < tmpList.size()-1) {
            m_highScoreList.removeOne(tmpList.at(i));
            m_highScoreList.append(newEntry);
            canBeInserted = true;
        }
    }

    qSort(m_highScoreList);

    return canBeInserted;
}

