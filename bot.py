import vk
import vk_api
from vk_api.longpoll import VkLongPoll, VkEventType

from cmath import inf
import discord
from discord_components import DiscordComponents, ComponentsBot, Button, SelectOption, Select
#import discord.ext.commands as commands
import random
import threading
import asyncio
from threading import Thread # Импортируем нужную библиотеку
import re

from config import settings

capt_zabiv_channel = 1034522667853815921 #828285598305091657 #канал для забива
capt_info_channel = 828210586529431572 #канал для информирвоания всех игроков

family_zabiv_channel = 956529985777172500
family_info_channel = 959861344822247495

moderator_roles = [
    1034524851467194438,  #помощник следака гетто в нелегалах828592338351423558
    1034524851467194438  #следак гетто в нелегаллах941014773875753000
]

fam_moderator_roles = [
    1034524851467194438 #следак за семьями на розе
]

trigger = [
    "капт",
    "откат",
    "мороз",
    "отказ",
    "отбив"
]

fam_trigger = [
    "забив",
    "откат",
    "отказ",
    "отбив"
]


#vk_session = vk_api.VkApi(token = settings['TOKEN_VK'])
#give = vk_session.get_api()
#longpoll = VkLongPoll(vk_session)



client = discord.Client()
DiscordComponents(client)


async def ButtonHandler(message, uniqueId):
    while True:
        response = await client.wait_for("button_click")
        for role in response.user.roles:
            if role.id in moderator_roles:
                if response.component.custom_id == "button1_{0}".format(uniqueId): 
                    await response.send(content = "**Одобрено! Администратор: **" + str(response.user.mention), ephemeral=False)
                    channel = client.get_channel(capt_info_channel)
                    author = message.author
                    embedVar = discord.Embed(title="🌹 Arizona Saint Rose 🌹| Система каптов гетто 🥩", description=f"", color=0x800080)
                    embedVar.add_field(name="** **", value=f"{author.mention}:\n```{message.content}```", inline=False)
                    embedVar.add_field(name="** **", value=f"**✅ Подтвердил администратор** {response.user.mention}", inline=False)
                    #человек, удаливший следующие две строки попадет в АД без очереди! 
                    avtor = '<@872929869384798248>'
                    embedVar.add_field(name="** **", value=f"Bot created with ❤️ by { avtor }", inline=False)
                    await channel.send(embed=embedVar)
                    #vk_session.method("messages.send", {"peer_id": settings['GROUP_ID_VK_GHETTO'], "message": f"🌹 Arizona Saint Rose 🌹| Система каптов гетто 🥩\n{author.name}:\n{message.content}\n✅ Подтвердил администратор {response.user.name}", "random_id": 0})
                    return
                elif response.component.custom_id == "button2_{0}".format(uniqueId): 
                    await response.send(content = "**Отказано! Администратор: **" + str(response.user.mention), ephemeral=False)

        for role in response.user.roles:
            if role.id in fam_moderator_roles:
                if response.component.custom_id == "button3_{0}".format(uniqueId): 
                    await response.send(content = "**Одобрено! Администратор: **" + str(response.user.mention), ephemeral=False)
                    channel = client.get_channel(family_info_channel)
                    author = message.author
                    embedVar = discord.Embed(title="🌹 Arizona Saint Rose 🌹| Система фам.каптов 🥕", description=f"", color=0x800080)
                    embedVar.add_field(name="** **", value=f"{author.mention}:\n```{message.content}```", inline=False)
                    embedVar.add_field(name="** **", value=f"**✅ Подтвердил администратор** {response.user.mention}", inline=False)
                    #человек, удаливший следующие две строки попадет в АД без очереди! 
                    avtor = '<@872929869384798248>'
                    embedVar.add_field(name="** **", value=f"Bot created with ❤️ by { avtor }", inline=False)
                    await channel.send(embed=embedVar)
                    #vk_session.method("messages.send", {"peer_id": settings['GROUP_ID_VK_FAMILY'], "message": f"🌹 Arizona Saint Rose 🌹| Система фам.каптов 🥕\n{author.name}:\n{message.content}\n✅ Подтвердил администратор {response.user.name}", "random_id": 0})
                    return
                elif response.component.custom_id == "button4_{0}".format(uniqueId): 
                    await response.send(content = "**Отказано! Администратор: **" + str(response.user.mention), ephemeral=False)


@client.event
async def on_message(message):
    if message.author.bot: return
    if message.channel.id == capt_zabiv_channel: 
        for msg in trigger:
            all_messages = message.content
            if msg in all_messages.lower():
                author = message.author
                sled_role = message.guild.get_role(role_id=1034524851467194438)
                help_sled_role = message.guild.get_role(role_id=1034524851467194438)
                uniqueId = random.getrandbits(64)
                await message.delete()
                await message.channel.send((f'**{ sled_role.mention } { help_sled_role.mention }\n{ message.content }. Отправитель: { author.mention }**'), components = [
                [
                    Button(label="Подтвердить", style="3", emoji = "🥳", custom_id="button1_{0}".format(uniqueId)), 
                    Button(label="Отказать", style="4", emoji = "🤬", custom_id="button2_{0}".format(uniqueId))
                ]
                ])
                asyncio.get_event_loop().create_task(ButtonHandler(message, uniqueId))

    if message.channel.id == family_zabiv_channel: 
        for msg in fam_trigger:
            all_messages = message.content
            if msg in all_messages.lower():
                author = message.author
                sled_role = message.guild.get_role(role_id=1034524851467194438)
                uniqueId = random.getrandbits(64)
                await message.delete()
                await message.channel.send((f'**{ sled_role.mention }\n{ message.content }. Отправитель: { author.mention }**'), components = [
                [
                    Button(label="Подтвердить", style="3", emoji = "🥳", custom_id="button3_{0}".format(uniqueId)), 
                    Button(label="Отказать", style="4", emoji = "🤬", custom_id="button4_{0}".format(uniqueId))
                ]
                ])
                asyncio.get_event_loop().create_task(ButtonHandler(message, uniqueId))

client.run(settings['TOKEN'])