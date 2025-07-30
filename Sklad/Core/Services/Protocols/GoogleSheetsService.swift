//
//  GoogleSheetsService.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.07.25.
//

// Общий протокол для работы с Google Sheets
protocol GoogleSheetsService: GoogleSheetsDataFetching,
                            GoogleSheetsDataWriting,
                            GoogleSheetsStructureManaging {}
