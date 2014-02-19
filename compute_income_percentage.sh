#!/bin/bash

declare -r bills=$(tail -n+2 ~/Dropbox/bills | cut -d, -f2 | paste -sd+ | bc)
declare -r expenses=$(cat ~/Dropbox/money | cut -d, -f2 | paste -sd+ | bc)
declare -r tickets=$(cat ~/Dropbox/tickets | cut -d, -f2- | sed -e 's/,/*/' | paste -sd+ | bc)
declare -r income=$(cat ~/projects/banca/income | cut -d, -f2 | paste -sd+ | bc)
declare -r total_expenses=$(echo "$bills + $expenses - $tickets" | bc)
declare -r percentage=$(echo "($total_expenses * 100) / $income" | bc)

echo -e "Income = $income\nBills = $bills\nExpenses = $expenses\nTickets = $tickets"
echo "Total expenses = Bills + Expenses - Tickets = $total_expenses"
echo "Percentage = $percentage%, Savings = $(echo 100 - $percentage | bc)%"
