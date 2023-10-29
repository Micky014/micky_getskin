------------------------
--====== Script ======--
------------------------

RegisterNetEvent('micky_getskin:getSkin', function(title)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('micky_getskin:sendSkin', skin, title)
    end)
end)