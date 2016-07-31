/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
#include <a_samp>                           // https://www.sa-mp.com/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
#define FolderPlayer "Database/%s.txt"
 
#define D_REG   0
#define D_LOG   1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
//native WP_Hash(buffer[], len, const str[]); // http://forum.sa-mp.com/showthread.php?t=570945
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
   
// REGISTER VARIABLE
new
    Pass           [MAX_PLAYERS],
    Skin           [MAX_PLAYERS],
    Kill           [MAX_PLAYERS],
    Death          [MAX_PLAYERS],
    Wanted         [MAX_PLAYERS],
    Administration [MAX_PLAYERS],
    
    Float: PosX    [MAX_PLAYERS],
    Float: PosY    [MAX_PLAYERS],
    Float: PosZ    [MAX_PLAYERS],
    Float: PosR    [MAX_PLAYERS];

// CONTROL VARIABLE
new
    C_Login        [MAX_PLAYERS];
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public OnPlayerConnect(playerid){
   
    C_Login        [playerid] =
 
    Pass           [playerid] =
    Kill           [playerid] =
    Death          [playerid] =
    Wanted         [playerid] =
    Administration [playerid] = 0;
    
    new
        string[39];
   
    format(string, sizeof(string),FolderPlayer,PlayerName(playerid));
   
    if(fexist(string)){
        ShowPlayerDialog(playerid, D_LOG, DIALOG_STYLE_INPUT,
            "Login",
                "Please enter your password with which you registered on the server",
            "confirm", "close");
    }
    else{
        ShowPlayerDialog(playerid, D_REG, DIALOG_STYLE_INPUT,
            "Registration",
                "Please type your password. The range of password is  4 - 19.",
            "confirm", "close");
    }
    return true;
}
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public OnPlayerDisconnect(playerid, reason){
    SaveData(playerid);
    return true;
}
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public OnPlayerRequestSpawn(playerid){
    if(C_Login[playerid]){
        SpawnPlayer         (playerid);
        SetPlayerSkin       (playerid, Skin[playerid]);
        SetPlayerPos        (playerid, PosX[playerid],PosY[playerid],PosZ[playerid]);
        SetPlayerFacingAngle(playerid, PosR[playerid]);
    }
    return false;
}
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public OnPlayerDeath(playerid, killerid, reason){
    if(killerid != INVALID_PLAYER_ID){
        Kill  [killerid]++;
        Death [playerid]++;
        Wanted[killerid]++;
    }
    return true;
}
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
    switch(dialogid){
        case D_REG:{
            if(response){
                if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid, D_REG, DIALOG_STYLE_INPUT,
                    "Registration",
                        "Please type your password. The range of password is  4 - 19.",
                    "confirm", "close");
                else if(strlen(inputtext) > 19) return ShowPlayerDialog(playerid, D_REG, DIALOG_STYLE_INPUT,
                    "Registration",
                        "Please type your password. The range of password is  4 - 19.",
                    "confirm", "close");
               
                C_Login[playerid] = 1;
 
                strins  (Pass[playerid], inputtext, 0);
                SaveData(playerid);
            }
            else Kick(playerid);
        }
        case D_LOG:{
            if(response){
                new
                    hash  [129],
                    string[129];
               
                format(string, sizeof(string),FolderPlayer,PlayerName(playerid));
               
                new
                    File:folder = fopen(string, io_readwrite);  
               
                if(folder){
               
                    fread(folder,string);
               
                    WP_Hash(hash,sizeof(hash),inputtext);
                    if(!strcmp(hash,string,false)){
                        LoadData(playerid);
                        strins(Pass[playerid], inputtext, 0);      
                    }
                    else ShowPlayerDialog(playerid, D_LOG, DIALOG_STYLE_INPUT,
                        "Login",
                            "Please enter your password with which you registered on the server.",
                        "confirm", "close");
                    fclose(folder);
                }
            }
            else Kick(playerid);
        }
    }
    return true;
}
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
stock
    SaveData(playerid){
        new
            hash  [129],
            string[200];
 
        format(string, sizeof(string),FolderPlayer,PlayerName(playerid));
 
        new
            File:folder = fopen(string, io_write);
        if(C_Login[playerid]){
            if(fexist(string)){
                if(folder){
                    WP_Hash             (hash,sizeof(hash),Pass[playerid]);
                    GetPlayerPos        (playerid, PosX[playerid],PosY[playerid],PosZ[playerid]);
                    GetPlayerFacingAngle(playerid, PosR[playerid]);
                   
                    format(string,200,"%s\r\n%f\r\n%f\r\n%f\r\n%f\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d",
                        hash,PosX[playerid],PosY[playerid],PosZ [playerid],PosR  [playerid],
                             Skin[playerid],Kill[playerid],Death[playerid],Wanted[playerid], Administration[playerid]);
                    fwrite(folder,string);
                    fclose(folder);
                }
                C_Login[playerid] = 1;
            }
            else{
                if(folder){
                    WP_Hash(hash,sizeof(hash),Pass[playerid]);
                   
                    format(string,200,"%s\r\n0\r\n0\r\n0\r\n0\r\n0\r\n0\r\n0\r\n0\r\n0",hash);
                    fwrite(folder,string);
                    fclose(folder);
                }
                PosX[playerid] =
                PosY[playerid] =
                PosZ[playerid] =
                PosR[playerid] = 0;
            }
        }
        return true;
    }
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
stock
    LoadData(playerid){
        new
            string[200];
       
        format(string, sizeof(string),FolderPlayer,PlayerName(playerid));
 
        new
            File:folder = fopen(string, io_read);  
       
        if(folder){
            fread(folder,string);
            fread(folder,string);PosX           [playerid] = strval(string);
            fread(folder,string);PosY           [playerid] = strval(string);
            fread(folder,string);PosZ           [playerid] = strval(string);
            fread(folder,string);PosR           [playerid] = strval(string);
            fread(folder,string);Skin           [playerid] = strval(string);
            fread(folder,string);Kill           [playerid] = strval(string);
            fread(folder,string);Death          [playerid] = strval(string);
            fread(folder,string);Wanted         [playerid] = strval(string);
            fread(folder,string);Administration [playerid] = strval(string);
            fclose(folder);
        }
        C_Login[playerid] = 1;
        return true;
    }
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
stock
    PlayerName(playerid){
        new
            name[MAX_PLAYER_NAME+1];
        GetPlayerName(playerid, name, sizeof(name));
        return name;
    }
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
