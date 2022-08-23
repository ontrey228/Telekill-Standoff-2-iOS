int (*get_team)(void*);
bool (*get_isLocal)(void*);
Vector3 (*get_position)(void*);
void (*set_position)(void*, Vector3);
void *(*get_transform)(void*);

void *me = NULL;
void *enemy = NULL;

void (*old_Player_Update)(void *player); 
void Player_Update(void *player) { 
	if(get_isLocal(player)) {
		me = player;
	}

	if(me != NULL) {
		if(get_team(me) != get_team(player)) {
			enemy = player;
		}

		if([switches isSwitchOn:@"Telekill"]) {
			Vector3 enemypos = get_position(get_transform(enemy));
			set_position(get_transform(me), Vector3(enemypos.X-1, enemypos.Y, enemypos.Z));
		} 
	} 
    old_Player_Update(player); 
} 
 
void setup() {
 
get_team = (int (*)(void *))getRealOffset(0x1A25E24);
get_isLocal = (bool (*)(void *))getRealOffset(0x1A26264);
get_position = (Vector3 (*)(void*))getRealOffset(0x270100C);
set_position = (void (*)(void*, Vector3))getRealOffset(0x27010BC);
get_transform = (void* (*)(void*))getRealOffset(0x26D3288);

HOOK(0x1A25490, Player_Update, old_Player_Update);

[switches addSwitch:@"Telekill" description:@"Teleport me to enemy"];

}
