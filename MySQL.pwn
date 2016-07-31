/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
#include <a_samp>                           // https://www.sa-mp.com/
#include <a_mysql>                          // http://forum.sa-mp.com/showthread.php?t=56564
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
#define FolderPlayer "Database/%s.txt"
 
#define MYSQL_DB     "Your_Database"    
#define MYSQL_USER   "Name"          
#define MYSQL_PASS   "Pass" 
#define MYSQL_HOST   "IP"  

#define D_REG   0
#define D_LOG   1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
native WP_Hash(buffer[], len, const str[]); // http://forum.sa-mp.com/showthread.php?t=570945
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

// MySQL 
new 
    MySQL;

// REGISTER VARIABLE
new
    ID             [MAX_PLAYERS],
    Skin           [MAX_PLAYERS],
    Kill           [MAX_PLAYERS],
    Death          [MAX_PLAYERS],
    Admin          [MAX_PLAYERS],
    Wanted         [MAX_PLAYERS],
    Password       [MAX_PLAYERS],
    
    Float: PosX    [MAX_PLAYERS],
    Float: PosY    [MAX_PLAYERS],
    Float: PosZ    [MAX_PLAYERS],
    Float: PosR    [MAX_PLAYERS];

// CONTROL VARIABLE
new
    C_Login        [MAX_PLAYERS];
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
forward OnAccountLoad(playerid);
forward OnAccountCheck(playerid);
forward OnAccountRegister(playerid);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public OnGameModeInit(){

    mysql_log(LOG_ERROR);
    
    MySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DB, MYSQL_PASS);

    if(mysql_errno() != 0)  printf("[MySQL] Connect is not succesfull!"); 
    else                    printf("[MySQL] Connect is succesfull!"); 
    return true;
}
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public OnPlayerConnect(playerid){
   
    C_Login        [playerid] =
 
    Kill           [playerid] =
    Death          [playerid] =
    Admin          [playerid] = 
    Wanted         [playerid] = 0;
    
    new 
        string[128];
    
    mysql_format(MySQL, string, sizeof(string), "SELECT `Password`, `ID` FROM `account` WHERE `UserName` = '%e' LIMIT 1", PlayerName(playerid)); 
    mysql_tquery(MySQL, string, "OnAccountCheck", "i", playerid); 
    return true;
}
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public OnPlayerDisconnect(playerid, reason){
    if(C_Login[playerid]){
        new 
            string[512];
            
        GetPlayerPos(playerid, PosX[playerid],PosY[playerid],PosZ[playerid]); 
        
        mysql_format(MySQL, string, sizeof(string), 
        "UPDATE `account` SET `Wanted` = %d, `Skin` = %d, `Kill` = %d,\
        `Death` = %d,`Admin` = %d, `PosX` = %f, `PosY` = %f, `PosZ` = %f, `PosR` = %f WHERE `ID` = %d",
        Wanted[playerid],Skin[playerid],Kill[playerid],Death[playerid],
        Admin[playerid],PosX[playerid],PosY[playerid],PosZ[playerid],PosR[playerid],ID[playerid]); 
        
        mysql_tquery(MySQL, string, "", ""); 
    }
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
                new 
                    string[500]; 
                     
                WP_Hash(Password[playerid], 129, inputtext); 
                mysql_format(MySQL, string, sizeof(string), "INSERT INTO `account` (`UserName`, `Password`) VALUES ('%e', '%e')", PlayerName(playerid), Password[playerid]); 
                mysql_tquery(MySQL, string, "OnAccountRegister", "i", playerid); 
                C_Login[playerid] = 1;
            }
            else Kick(playerid);
        }
        case D_LOG:{
            if(response){  
                new 
                    string  [225],
                    hashpass[129];      
                WP_Hash(hashpass, sizeof(hashpass), inputtext); 
                if(!strcmp(hashpass, Password[playerid])){ 
                    mysql_format(MySQL, string, sizeof(string), "SELECT * FROM `account` WHERE `UserName` = '%e' LIMIT 1", PlayerName(playerid)); 
                    mysql_tquery(MySQL, string, "OnAccountLoad", "i", playerid); 
                    C_Login[playerid] = 1;
                } 
                else ShowPlayerDialog(playerid, D_LOG, DIALOG_STYLE_INPUT, "Login", "Please enter your password with which you registered on the server.", "confirm", "close"); 
            } 
            else Kick(playerid);
        }
    }
    return true;
}
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public 
    OnAccountCheck(playerid){
        new 
            rows, fields; 

        cache_get_data(rows, fields, MySQL); 
         
        if(rows){ 
            cache_get_field_content(0, "Password", Password[playerid], MySQL, 129); 
            ID[playerid] = cache_get_field_content_int(0, "ID"); 
            
            ShowPlayerDialog(playerid, D_LOG, DIALOG_STYLE_INPUT, 
            "Login", 
                "Please enter your password with which you registered on the server.", 
            "confirm", "close");  
        } 
        else ShowPlayerDialog(playerid, D_REG, DIALOG_STYLE_INPUT, 
            "Registration", 
                "Please type your password. The range of password is  4 - 19.", 
            "confirm", "close"); 
        return true;
    }
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public 
    OnAccountLoad(playerid){ 
        Wanted         [playerid] = cache_get_field_content_int  (0, "Wanted");  
        Skin           [playerid] = cache_get_field_content_int  (0, "Skin"  ); 
        Kill           [playerid] = cache_get_field_content_int  (0, "Kill"  ); 
        Death          [playerid] = cache_get_field_content_int  (0, "Death" );  
        Admin          [playerid] = cache_get_field_content_int  (0, "Admin" );
        PosX           [playerid] = cache_get_field_content_float(0, "PosX"  );
        PosY           [playerid] = cache_get_field_content_float(0, "PosY"  );
        PosZ           [playerid] = cache_get_field_content_float(0, "PosZ"  ); 
        PosR           [playerid] = cache_get_field_content_float(0, "PosR"  ); 
        return true; 
    }
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/  
public 
    OnAccountRegister(playerid){ 
        ID    [playerid] = cache_insert_id(); 
        PosX  [playerid] = 1682.7249;
        PosY  [playerid] = 1451.3008;
        PosZ  [playerid] =   10.7719;
        printf("[Registration] New account registered. Database ID: [%d]",ID[playerid]); 
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
